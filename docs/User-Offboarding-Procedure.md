\# Microsoft 365 User Offboarding Procedure



\## Scenario



A controlled Microsoft 365 / Entra ID offboarding procedure was

performed for a lab user.



The objective was to remove the user's access while preserving the

account instead of permanently deleting it.



The procedure included account blocking, session revocation, group

membership review, license removal, and final access validation.



\---



\## Technologies



\- Microsoft Entra ID

\- Microsoft 365

\- Microsoft 365 Admin Center

\- Entra user and group management

\- Authentication / sign-in validation



\---



\## Initial Assessment



Before making changes, the user configuration was reviewed.



The test account was initially:



\- Enabled

\- Member of two groups

\- Assigned one Microsoft 365 Business Premium license

\- Not assigned any administrative role

\- Previously active in Microsoft 365



This baseline was recorded before beginning the offboarding process.



\---



\## Offboarding Workflow



The controlled offboarding followed this sequence:



\*\*Review → Block Sign-in → Revoke Sessions → Review Groups → Remove Access → Remove License → Validate\*\*



The account was intentionally preserved rather than permanently

deleted.



\---



\## Step 1 — Block User Sign-in



The user account was disabled in Microsoft Entra ID.



This prevented the account from being used for new authentication.



Account state after the change:



`Disabled`



\---



\## Step 2 — Revoke Active Sessions



Existing authentication sessions were revoked.



This step was performed in addition to disabling the account so that

previously issued sessions would not be relied upon for continued

access.



\---



\## Step 3 — Review Group Memberships



The user's existing group memberships were reviewed before removal.



The account belonged to:



\- A Microsoft 365 group

\- A departmental security group



The memberships were removed as part of the controlled offboarding.



Final group-membership count:



`0`



\---



\## Step 4 — Review Administrative Access



The user was verified to have no assigned administrative roles.



No privileged-role removal was therefore required.



This check was performed before considering the access-removal process

complete.



\---



\## Step 5 — Remove Microsoft 365 License



The user had one directly assigned:



`Microsoft 365 Business Premium`



license.



After the access requirements had been reviewed, the direct license was

removed.



Final assigned-license count:



`0`



\---



\## Step 6 — Authentication Validation



After completing the administrative changes, an authentication attempt

was performed using the offboarded account.



The password-based authentication test returned a Microsoft message

indicating that the account was blocked and required administrator

action to restore access.



This provided user-side evidence that the account could no longer be

used normally after the offboarding procedure.



\---



\## Final State



The final account state was validated as:



\- Account disabled

\- Sessions revoked

\- Group memberships removed

\- No administrative roles

\- Microsoft 365 license removed

\- Authentication blocked

\- User object preserved



The account was not permanently deleted.



\---



\## Troubleshooting Note



An initial authentication attempt using a passkey produced an error

that did not by itself provide sufficient evidence that the disabled

account state was responsible for the failure.



Rather than treating that error as proof, the validation was repeated

using password authentication.



The second test produced a clear blocked-account message.



This distinction was important because an authentication error should

not automatically be attributed to account disablement without

supporting evidence.



\---



\## Operational Considerations



A real production offboarding process may require additional actions

depending on organizational policy, including:



\- Mailbox retention or conversion

\- OneDrive data retention or transfer

\- Ownership transfer for shared resources

\- Device recovery

\- Application-specific access removal

\- Legal or compliance retention requirements



These actions were outside the scope of this controlled lab scenario.



\---



\## Outcome



The lab demonstrated a structured Microsoft 365 / Entra ID user

offboarding workflow including:



\- Pre-change account assessment

\- Sign-in blocking

\- Session revocation

\- Group-membership review and removal

\- Administrative-role verification

\- License removal

\- Post-change authentication testing

\- Preservation of the user object

\- Evidence-based validation



The scenario was executed in a controlled Microsoft 365 / Entra ID lab

environment and does not represent production enterprise experience.

