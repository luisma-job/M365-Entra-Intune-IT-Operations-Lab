\# Conditional Access Troubleshooting



\## Scenario



A Microsoft 365 / Entra ID lab environment was used to validate a

controlled Conditional Access incident affecting user access to

Microsoft 365.



The objective was to reproduce an access failure, investigate the

sign-in logs, identify the Conditional Access policy responsible for

the failure, correct the configuration, and validate service recovery.



\---



\## Technologies



\- Microsoft Entra ID

\- Conditional Access

\- Microsoft 365

\- Multi-Factor Authentication (MFA)

\- Microsoft Entra Sign-in Logs

\- Security Defaults



\---



\## Initial Environment



The tenant initially used Microsoft Entra Security Defaults.



Before replacing that protection with lab Conditional Access policies,

administrative access safeguards were prepared and validated.



A dedicated emergency administrative account was configured with the

Global Administrator role and excluded from the relevant lab

Conditional Access policies.



Authentication of the emergency account was tested before continuing

with the migration.



\---



\## Conditional Access Configuration



The lab used several Conditional Access policies with different

purposes.



\### Global Administrator protection



`LAB-CA-Protect-GlobalAdmin-MFA`



Purpose:



\- Protect privileged administrative access.

\- Require MFA for the Global Administrator.

\- Validate behavior first using Report-only mode.



\### All Users MFA



`LAB-CA-AllUsers-MFA`



Purpose:



\- Target all users.

\- Target all cloud resources.

\- Require MFA.

\- Exclude the emergency administrative account.



The policy was initially tested in Report-only mode before activation.



\### Controlled Microsoft 365 block



`LAB-CA-Laura-Block-M365`



Purpose:



\- Target a test user.

\- Target Microsoft 365.

\- Block access.

\- Reproduce a controlled Conditional Access incident.



\---



\## Security Defaults Migration



Security Defaults and custom Conditional Access policies were not

changed simultaneously without validation.



The migration followed this sequence:



1\. Prepare the administrative MFA policy.

2\. Configure and test the emergency administrative account.

3\. Exclude the emergency account from the relevant lab policies.

4\. Validate Conditional Access behavior in Report-only mode.

5\. Configure the All Users MFA policy.

6\. Disable Security Defaults.

7\. Activate the All Users MFA Conditional Access policy.

8\. Validate administrative authentication again.



This provided an alternative access-control configuration before the

controlled user incident was reproduced.



\---



\## Controlled Incident



The Microsoft 365 blocking policy was activated for the test user.



When the user attempted to access Outlook on the web, authentication

succeeded but access to the resource was denied.



The user received a message indicating that the account had signed in

successfully but did not have permission to access the resource.



\---



\## Investigation



Microsoft Entra Sign-in Logs were reviewed.



The affected sign-in showed:



\- Application: Outlook on the web

\- Sign-in status: Failure

\- Error code: `53003`

\- Conditional Access result: Blocked



The sign-in details reported:



`Access has been blocked by Conditional Access policies. The access policy does not allow token issuance.`



Conditional Access evaluation showed that the controlled Microsoft 365

blocking policy failed the access evaluation while the general MFA

policy was satisfied.



\---



\## Root Cause



The root cause was the active Conditional Access policy:



`LAB-CA-Laura-Block-M365`



The policy was intentionally configured to block the test user's

Microsoft 365 access.



This demonstrated that the authentication credentials themselves were

not the cause of the incident.



The failure occurred during Conditional Access policy evaluation after

authentication.



\---



\## Corrective Action



The blocking Conditional Access policy was disabled.



No user password reset or unnecessary account modification was

performed because the sign-in evidence identified the access policy as

the cause.



\---



\## Validation



After disabling the blocking policy, the user authentication flow was

tested again.



Validation confirmed:



\- User access was restored.

\- The All Users MFA policy remained active.

\- MFA requirements were successfully satisfied.

\- The controlled blocking policy was disabled.



The incident was therefore resolved without removing the tenant-wide

MFA protection.



\---



\## Troubleshooting Workflow



The incident followed this operational workflow:



\*\*Reproduce → Observe → Investigate → Identify Root Cause → Correct → Validate\*\*



The key troubleshooting source was Microsoft Entra Sign-in Logs rather

than making configuration changes based only on the user-facing error.



\---



\## Outcome



The lab demonstrated practical troubleshooting of Microsoft Entra

Conditional Access, including:



\- Report-only policy testing

\- MFA enforcement

\- Security Defaults migration

\- Emergency administrative access planning

\- Controlled access blocking

\- Sign-in log analysis

\- Error code `53003`

\- Root-cause identification

\- Policy correction

\- Recovery validation



The scenario was executed in a controlled Microsoft 365 / Entra ID lab

environment and does not represent production enterprise experience.

