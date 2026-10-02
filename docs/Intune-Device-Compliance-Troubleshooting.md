\# Intune Device Compliance Troubleshooting



\## Scenario



A Windows 11 device managed by Microsoft Intune was used to reproduce

and troubleshoot a controlled device-compliance incident.



The objective was to deliberately create a noncompliant state, identify

the affected compliance setting, correct the local configuration, force

policy synchronization, and verify that the device returned to a

compliant state.



\---



\## Technologies



\- Microsoft Intune

\- Windows 11

\- Microsoft Entra ID

\- Windows Defender Firewall

\- PowerShell

\- Intune Company Portal / device synchronization



\---



\## Test Device



Device:



`PC-INTUNE01`



Environment:



\- Windows 11 virtual machine

\- Microsoft Intune managed

\- Corporate ownership

\- Microsoft Corporation virtual machine



Before the controlled incident, the device reported:



`Compliant`



\---



\## Compliance Policy



The device was evaluated against the lab compliance policy:



`WIN11-LAB-Compliance-Firewall`



The relevant compliance setting was:



`Firewall`



Before the test, the setting reported:



`Compliant`



\---



\## Baseline Validation



Windows Firewall status was checked locally with PowerShell.



All three firewall profiles were enabled:



\- Domain: `True`

\- Private: `True`

\- Public: `True`



This established the known-good baseline before introducing the

controlled failure.



\---



\## Controlled Incident



To reproduce a compliance failure, Windows Firewall was disabled for

all profiles from an elevated PowerShell session:



`Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False`



Local validation confirmed:



\- Domain: `False`

\- Private: `False`

\- Public: `False`



The device was then synchronized with Microsoft Intune.



\---



\## Detection



After synchronization, Intune reported a partial policy result and the

device changed from:



`Compliant`



to:



`Noncompliant`



The compliance-policy details identified:



`Firewall — Noncompliant`



This narrowed the investigation to the Windows Firewall configuration.



\---



\## Root Cause



The device did not satisfy the requirements of:



`WIN11-LAB-Compliance-Firewall`



because all Windows Firewall profiles had been disabled locally.



The compliance failure was therefore caused by a controlled endpoint

configuration change rather than an enrollment or identity problem.



\---



\## Corrective Action



Windows Firewall was enabled again for all profiles:



`Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True`



Local PowerShell validation confirmed:



\- Domain: `True`

\- Private: `True`

\- Public: `True`



The device was synchronized with Microsoft Intune again.



\---



\## Validation



After remediation and synchronization:



\- Policy synchronization completed successfully.

\- The device returned to `Compliant`.

\- The firewall compliance setting returned to `Compliant`.

\- Local PowerShell validation confirmed all firewall profiles remained

&#x20; enabled.



The synchronization result reported successful processing of all

evaluated policies.



\---



\## Troubleshooting Workflow



The scenario followed this operational workflow:



\*\*Baseline → Reproduce → Synchronize → Detect → Diagnose → Correct → Synchronize → Validate\*\*



Both local endpoint evidence and Microsoft Intune compliance evidence

were used before considering the incident resolved.



\---



\## Outcome



The lab demonstrated practical Intune device-compliance troubleshooting,

including:



\- Establishing a known-good baseline

\- Creating a controlled noncompliant condition

\- PowerShell-based endpoint validation

\- Intune policy synchronization

\- Compliance-policy investigation

\- Root-cause identification

\- Endpoint remediation

\- Compliance recovery validation



The scenario was executed in a controlled Microsoft Intune lab

environment and does not represent production enterprise experience.

