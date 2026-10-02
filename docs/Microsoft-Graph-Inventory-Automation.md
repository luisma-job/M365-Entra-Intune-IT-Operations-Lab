\# Ticket 005 — Microsoft Graph Inventory Automation



\## Scenario



The IT operations team needs a repeatable way to collect basic inventory

information from Microsoft Entra ID and Microsoft 365.



The objective is to automate the collection of:



\- Users

\- Groups

\- Microsoft 365 license availability



The solution must generate CSV reports, validate the generated files,

handle execution errors, and work independently of a fixed local path.



\---



\## Technologies



\- PowerShell 5.1

\- Microsoft Graph PowerShell SDK

\- Microsoft Entra ID

\- Microsoft 365

\- CSV reporting



\---



\## Solution



The script `M365-Entra-InventoryReport.ps1` connects to Microsoft Graph

using delegated permissions.



Required Microsoft Graph scopes:



\- `User.Read.All`

\- `Group.Read.All`

\- `Directory.Read.All`



The script follows the workflow:



\*\*Validate → Execute → Verify → Record\*\*



\### Validate



Before generating reports, the script:



1\. Determines the report directory relative to `$PSScriptRoot`.

2\. Creates the `Reports` directory when necessary.

3\. Verifies that Microsoft Graph PowerShell is available.

4\. Checks for an existing Microsoft Graph session.

5\. Starts authentication when no session exists.

6\. Verifies the required Microsoft Graph permissions.



\### Execute



The script retrieves:



\- Entra ID users and account status

\- Entra ID / Microsoft 365 groups

\- Microsoft 365 subscribed SKU information



It generates:



\- `Users-Report.csv`

\- `Groups-Report.csv`

\- `Licenses-Report.csv`



\### Verify



After generation, the script verifies:



\- Each expected CSV exists.

\- Each file has content.

\- Each CSV can be imported.

\- Each CSV contains at least one record.



\### Record



The execution summary records:



\- Number of users retrieved

\- Number of groups retrieved

\- Number of license SKUs retrieved

\- Report location

\- Global execution status



Possible final states:



\- `SUCCESS`

\- `COMPLETED WITH ERRORS`



\---



\## Troubleshooting Case 1 — PowerShell Execution Policy



\### Problem



The Microsoft Graph Authentication module was installed, but

`Connect-MgGraph` could not be loaded.



\### Diagnosis



Importing the module explicitly showed that PowerShell script execution

was disabled for the current environment.



The execution policy was reviewed with:



`Get-ExecutionPolicy -List`



\### Corrective Action



A temporary change was applied only to the current PowerShell process:



`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process`



This avoided making a broader persistent execution-policy change.



\### Validation



`Microsoft.Graph.Authentication` loaded successfully and

`Connect-MgGraph` became available.



\---



\## Troubleshooting Case 2 — Report File Locked



\### Problem



A controlled test was performed while `Users-Report.csv` was locked

with exclusive file access.



The script retrieved the users from Microsoft Graph but could not

overwrite the CSV file.



\### Result



The users report generated an error while the groups and licenses

reports continued processing.



The script correctly finished with:



`Status: COMPLETED WITH ERRORS`



This demonstrated that a partial failure is not reported as a

successful execution.



\### Recovery



The file lock was released and the script was executed again.



Final result:



`Status: SUCCESS`



\---



\## Validation Results



Successful lab execution produced:



\- 4 users

\- 9 groups

\- 1 Microsoft 365 subscribed SKU

\- 3 validated CSV reports



License inventory during the test:



\- SKU: `SPB`

\- Total units: 25

\- Consumed units: 1

\- Available units: 24



These values represent the lab environment at the time of testing and

are not hard-coded into the script.



\---



\## Portability



The report location is calculated using:



`$PSScriptRoot`



This means the script does not depend on a fixed path such as

`C:\\LAB-01`.



Example:



If the script is located in:



`C:\\M365-Entra-Intune-IT-Operations-Lab`



reports are generated in:



`C:\\M365-Entra-Intune-IT-Operations-Lab\\Reports`



The same structure can therefore be used after cloning the repository

to another location.



\---



\## Outcome



The ticket delivered a reusable PowerShell inventory script integrating

Microsoft Graph with validation, error handling, CSV reporting, and

controlled troubleshooting tests.



The implementation was developed and validated in a lab Microsoft 365 /

Entra ID environment.

