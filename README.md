# Windows Help Desk Troubleshooting Lab

A portfolio lab for entry level IT Support and Service Desk roles. It combines a **read-only PowerShell diagnostic script**, a simple triage workflow, and three **fictional** ticket examples. No production environment or real customer data was used.

## Skills demonstrated

- Windows system checks: OS, boot time, memory, CPU and free disk space
- Network triage: adapter state, IP configuration, DNS and HTTPS reachability
- Ticket handling: impact and urgency, troubleshooting notes, resolution and user confirmation
- Clear escalation and privacy conscious documentation

## Run the script on your own Windows computer

Open PowerShell in the project folder and run:

```powershell
.\scripts\Get-HelpdeskSnapshot.ps1
```

If your execution policy prevents the script from running, inspect the script first and run it in a temporary process scope:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\Get-HelpdeskSnapshot.ps1
```

The script creates an `output/` folder with a timestamped text report. It reads system settings and runs connectivity checks; it does not repair, delete or change settings. Some checks may be unavailable on restricted machines, and the report records that instead. Do not run it on an employer device without permission. The report may contain identifying system information, so **do not commit or share it without review and redaction**. The `output/` folder is ignored by Git.

## Support workflow

1. Record the user's symptom, start time, device, location and business impact.
2. Check whether the issue affects one person or many; assess urgency.
3. Reproduce the issue where safe, then collect relevant facts and diagnostic results.
4. Try a reversible fix with the user's consent; record what changed and the result.
5. Escalate with evidence if access, security, or broader infrastructure is involved.
6. Ask the user to confirm service is restored; close the ticket with clear notes.

## Example tickets

| Ticket | Scenario | Core check | Outcome |
| --- | --- | --- | --- |
| [HD-001](tickets/HD-001-slow-pc.md) | Slow Windows PC | Disk space and startup load | Storage cleanup guidance |
| [HD-002](tickets/HD-002-dns.md) | Website fails to load | DNS versus TCP connectivity | DNS setting escalation |
| [HD-003](tickets/HD-003-account-lockout.md) | Account locked | Identity verification and lockout policy | Access team escalation |
| [HD-004](tickets/HD-004-personal-device-check.md) | Personal Windows device check | Disk space, DNS and HTTPS | Diagnostic checks completed |

HD-001 to HD-003 are simulated support tickets. HD-004 documents diagnostic checks performed on my own Windows laptop.


