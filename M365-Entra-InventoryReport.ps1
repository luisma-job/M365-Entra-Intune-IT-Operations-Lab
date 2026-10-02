<#
.SYNOPSIS
    Generates Microsoft 365 and Entra ID inventory reports.

.DESCRIPTION
    Connects to Microsoft Graph and generates CSV inventory reports
    for users, groups, and Microsoft 365 licenses.

    The Reports directory is created relative to the script location,
    allowing the project to run from different paths without requiring
    hard-coded local directories.

.NOTES
    Project: M365-Entra-Intune-IT-Operations-Lab
    Script: M365-Entra-InventoryReport.ps1
    Environment: Microsoft 365 / Entra ID Lab

    Script workflow:
    Validate -> Execute -> Verify -> Record
#>

# ============================================================
# 1. Configuration
# ============================================================

$ReportPath = Join-Path $PSScriptRoot "Reports"

$ExecutionSuccessful = $true

$RequiredScopes = @(
    "User.Read.All"
    "Group.Read.All"
    "Directory.Read.All"
)

Write-Host ""
Write-Host "=== M365 / Entra ID Inventory Report ==="
Write-Host "Project: M365-Entra-Intune-IT-Operations-Lab"
Write-Host "Report path: $ReportPath"
Write-Host ""


# ============================================================
# 2. Validate report directory
# ============================================================

try {

    if (-not (Test-Path $ReportPath)) {

        New-Item `
            -Path $ReportPath `
            -ItemType Directory `
            -Force `
            -ErrorAction Stop |
            Out-Null

        Write-Host "Report directory created."
    }
    else {
        Write-Host "Report directory already exists."
    }

}
catch {

    Write-Error "Failed to create or access report directory: $($_.Exception.Message)"

    exit 1
}


# ============================================================
# 3. Validate Microsoft Graph PowerShell SDK
# ============================================================

if (-not (Get-Module Microsoft.Graph.Authentication -ListAvailable)) {

    Write-Error "Microsoft Graph PowerShell SDK is not installed."

    exit 1
}

Write-Host "Microsoft Graph PowerShell SDK detected."


# ============================================================
# 4. Microsoft Graph connection
# ============================================================

try {

    $MgContext = Get-MgContext

    if (-not $MgContext) {

        Write-Host "No active Microsoft Graph session detected."
        Write-Host "Connecting to Microsoft Graph..."

        Connect-MgGraph `
            -Scopes $RequiredScopes `
            -ErrorAction Stop

        $MgContext = Get-MgContext
    }
    else {

        Write-Host "Existing Microsoft Graph session detected."
    }

    if (-not $MgContext) {

        throw "Microsoft Graph context could not be obtained."
    }

    Write-Host "Connected account: $($MgContext.Account)"

}
catch {

    Write-Error "Failed to connect to Microsoft Graph: $($_.Exception.Message)"

    exit 1
}


# ============================================================
# 5. Validate Microsoft Graph permissions
# ============================================================

$MissingScopes = $RequiredScopes | Where-Object {
    $_ -notin $MgContext.Scopes
}

if ($MissingScopes) {

    Write-Host "Missing required Microsoft Graph permissions:"

    $MissingScopes | ForEach-Object {
        Write-Host " - $_"
    }

    Write-Host "Reconnecting with the required permissions..."

    try {

        Connect-MgGraph `
            -Scopes $RequiredScopes `
            -ErrorAction Stop

        $MgContext = Get-MgContext

        $MissingScopes = $RequiredScopes | Where-Object {
            $_ -notin $MgContext.Scopes
        }

        if ($MissingScopes) {

            throw "The required Microsoft Graph permissions were not granted."
        }

        Write-Host "Required Microsoft Graph permissions validated."
    }
    catch {

        Write-Error "Failed to obtain required Microsoft Graph permissions: $($_.Exception.Message)"

        exit 1
    }
}
else {

    Write-Host "Required Microsoft Graph permissions validated."
}


# ============================================================
# 6. Generate users report
# ============================================================

Write-Host ""
Write-Host "Generating users report..."

try {

    $Users = Get-MgUser `
        -All `
        -Property `
            "DisplayName",
            "UserPrincipalName",
            "AccountEnabled",
            "Department",
            "JobTitle" `
        -ErrorAction Stop

    $Users |
        Select-Object `
            DisplayName,
            UserPrincipalName,
            AccountEnabled,
            Department,
            JobTitle |
        Export-Csv `
            -Path (Join-Path $ReportPath "Users-Report.csv") `
            -NoTypeInformation `
            -Encoding UTF8 `
            -ErrorAction Stop

    Write-Host "Users report generated successfully: $($Users.Count) users."
}
catch {

    $ExecutionSuccessful = $false

    Write-Error "Failed to generate users report: $($_.Exception.Message)"
}


# ============================================================
# 7. Generate groups report
# ============================================================

Write-Host "Generating groups report..."

try {

    $Groups = Get-MgGroup `
        -All `
        -Property `
            "DisplayName",
            "GroupTypes",
            "SecurityEnabled",
            "MailEnabled" `
        -ErrorAction Stop

    $Groups |
        Select-Object `
            DisplayName,
            @{
                Name = "GroupType"
                Expression = {

                    if ($_.GroupTypes -contains "Unified") {
                        "Microsoft 365"
                    }
                    elseif ($_.SecurityEnabled) {
                        "Security"
                    }
                    else {
                        "Other"
                    }
                }
            },
            SecurityEnabled,
            MailEnabled |
        Export-Csv `
            -Path (Join-Path $ReportPath "Groups-Report.csv") `
            -NoTypeInformation `
            -Encoding UTF8 `
            -ErrorAction Stop

    Write-Host "Groups report generated successfully: $($Groups.Count) groups."
}
catch {

    $ExecutionSuccessful = $false

    Write-Error "Failed to generate groups report: $($_.Exception.Message)"
}


# ============================================================
# 8. Generate licenses report
# ============================================================

Write-Host "Generating licenses report..."

try {

    $Licenses = Get-MgSubscribedSku -ErrorAction Stop

    $Licenses |
        Select-Object `
            SkuPartNumber,
            ConsumedUnits,
            @{
                Name = "TotalUnits"
                Expression = {
                    $_.PrepaidUnits.Enabled
                }
            },
            @{
                Name = "AvailableUnits"
                Expression = {
                    $_.PrepaidUnits.Enabled - $_.ConsumedUnits
                }
            } |
        Export-Csv `
            -Path (Join-Path $ReportPath "Licenses-Report.csv") `
            -NoTypeInformation `
            -Encoding UTF8 `
            -ErrorAction Stop

    Write-Host "Licenses report generated successfully: $($Licenses.Count) SKU(s)."
}
catch {

    $ExecutionSuccessful = $false

    Write-Error "Failed to generate licenses report: $($_.Exception.Message)"
}


# ============================================================
# 9. Validate generated report files
# ============================================================

Write-Host ""
Write-Host "Validating generated reports..."

$ReportFiles = @(
    (Join-Path $ReportPath "Users-Report.csv")
    (Join-Path $ReportPath "Groups-Report.csv")
    (Join-Path $ReportPath "Licenses-Report.csv")
)

foreach ($File in $ReportFiles) {

    if (Test-Path $File) {

        $FileInfo = Get-Item $File

        if ($FileInfo.Length -gt 0) {

            Write-Host "OK - $($FileInfo.Name) - $($FileInfo.Length) bytes"
        }
        else {

            $ExecutionSuccessful = $false

            Write-Error "Report file is empty: $File"
        }
    }
    else {

        $ExecutionSuccessful = $false

        Write-Error "Report file not found: $File"
    }
}


# ============================================================
# 10. Validate CSV content
# ============================================================

Write-Host "Validating CSV content..."

foreach ($File in $ReportFiles) {

    if (-not (Test-Path $File)) {
        continue
    }

    try {

        $CsvData = Import-Csv `
            -Path $File `
            -ErrorAction Stop

        $RowCount = @($CsvData).Count

        if ($RowCount -gt 0) {

            Write-Host "OK - $(Split-Path $File -Leaf) contains $RowCount record(s)."
        }
        else {

            $ExecutionSuccessful = $false

            Write-Error "$(Split-Path $File -Leaf) contains no records."
        }
    }
    catch {

        $ExecutionSuccessful = $false

        Write-Error "Failed to validate $(Split-Path $File -Leaf): $($_.Exception.Message)"
    }
}


# ============================================================
# 11. Execution summary
# ============================================================

Write-Host ""
Write-Host "=== Execution Summary ==="

if ($null -ne $Users) {
    Write-Host "Users:    $($Users.Count)"
}
else {
    Write-Host "Users:    ERROR"
}

if ($null -ne $Groups) {
    Write-Host "Groups:   $($Groups.Count)"
}
else {
    Write-Host "Groups:   ERROR"
}

if ($null -ne $Licenses) {
    Write-Host "Licenses: $($Licenses.Count)"
}
else {
    Write-Host "Licenses: ERROR"
}

Write-Host "Reports:  $ReportPath"

if ($ExecutionSuccessful) {

    Write-Host ""
    Write-Host "Status: SUCCESS"
    Write-Host "Inventory reports generated and validated successfully."
}
else {

    Write-Host ""
    Write-Warning "Status: COMPLETED WITH ERRORS"
    Write-Warning "Review the errors above before using the generated reports."
}