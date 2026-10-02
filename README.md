\# Microsoft 365, Entra ID \& Intune IT Operations Lab



Hands-on IT operations lab focused on Microsoft 365 administration,

Microsoft Entra ID, Conditional Access, Intune device compliance,

PowerShell, and Microsoft Graph.



The project simulates common identity, access, endpoint, and

administration tasks in a controlled Microsoft 365 environment.



> This is a personal lab project designed to demonstrate practical

> administration and troubleshooting skills. It does not represent

> production enterprise experience.



\---



\## What This Project Demonstrates



\- Microsoft Entra ID user and group administration

\- Microsoft 365 license management

\- Conditional Access configuration and troubleshooting

\- Multi-Factor Authentication (MFA)

\- Microsoft Entra Sign-in Logs analysis

\- Emergency administrative access planning

\- Microsoft Intune device compliance

\- Windows Firewall compliance troubleshooting

\- User onboarding and offboarding workflows

\- PowerShell automation

\- Microsoft Graph PowerShell SDK

\- CSV inventory reporting

\- Error handling and execution validation



\---



\## Lab Scenarios



\### Conditional Access Troubleshooting



A controlled Microsoft 365 access failure was reproduced using

Conditional Access.



Microsoft Entra Sign-in Logs were used to investigate error `53003`,

identify the blocking policy, correct the configuration, and validate

service recovery while maintaining MFA protection.



\[View documentation](docs/Conditional-Access-Troubleshooting.md)



\---



\### Intune Device Compliance Troubleshooting



A Windows 11 device was deliberately moved from a compliant to a

noncompliant state by changing its Windows Firewall configuration.



Microsoft Intune and local PowerShell evidence were used to identify

the compliance failure, restore the required configuration, synchronize

the device, and validate its return to a compliant state.



\[View documentation](docs/Intune-Device-Compliance-Troubleshooting.md)



\---



\### Microsoft 365 User Offboarding



A controlled offboarding workflow was performed without permanently

deleting the user account.



The process included sign-in blocking, session revocation, group

membership review and removal, license removal, and post-change

authentication validation.



\[View documentation](docs/User-Offboarding-Procedure.md)



\---



\### Microsoft Graph Inventory Automation



`M365-Entra-InventoryReport.ps1` automates basic Microsoft 365 and

Entra ID inventory collection using Microsoft Graph.



The script retrieves:



\- Users and account status

\- Groups and group type

\- Microsoft 365 subscribed license SKUs



It also validates generated reports and tracks the overall execution

state so that partial failures are not reported as successful runs.



\[View documentation](docs/Microsoft-Graph-Inventory-Automation.md)



\---



\## PowerShell Workflow



The automation follows the operational pattern:



\*\*Validate → Execute → Verify → Record\*\*



The script:



1\. Validates the report directory.

2\. Checks Microsoft Graph PowerShell availability.

3\. Establishes or reuses a Graph session.

4\. Validates required Graph permissions.

5\. Retrieves users, groups, and license information.

6\. Exports CSV reports.

7\. Validates generated files and CSV content.

8\. Produces a final execution status.



Possible final states include:



`SUCCESS`



and



`COMPLETED WITH ERRORS`



\---



\## Microsoft Graph Permissions



The inventory script uses delegated Microsoft Graph permissions:



\- `User.Read.All`

\- `Group.Read.All`

\- `Directory.Read.All`



Interactive authentication is used when an existing Graph session is

not available.



\---



\## Repository Structure

```text
M365-Entra-Intune-IT-Operations-Lab/
|
+-- M365-Entra-InventoryReport.ps1
+-- README.md
+-- .gitignore
|
+-- docs/
|   +-- Conditional-Access-Troubleshooting.md
|   +-- Intune-Device-Compliance-Troubleshooting.md
|   +-- Microsoft-Graph-Inventory-Automation.md
|   +-- User-Offboarding-Procedure.md
|
+-- samples/
    +-- Users-Report-Sample.csv
    +-- Groups-Report-Sample.csv
    +-- Licenses-Report-Sample.csv
```

The local `Reports/` directory is excluded from Git because it contains
output generated directly from the lab tenant.

The `samples/` directory contains sanitized example output for
demonstration purposes.
