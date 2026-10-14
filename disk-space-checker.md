# Disk Space Checker

This PowerShell 5.1+ tool adds percentage-based disk-space triage and CSV reporting to the Windows Help Desk Troubleshooting Lab. Live mode reads fixed-drive metadata from Windows. It writes a report but does not clean disks or change settings.

## Run from the project folder

First, try fictional data:

```powershell
.\scripts\Get-DiskSpaceCheck.ps1 -Demo
```

Expected demo results: C: 35% free (`OK`), D: 8% (`Low`), E: 3% (`Critical`). These are fictional drives, not observations from your device. Demo CSV files contain `Mode=Demo` and have `Demo` in their filename.

Then check your own Windows device:

```powershell
.\scripts\Get-DiskSpaceCheck.ps1
```

CSV files are saved under `output/` beside the project scripts folder. This folder is already excluded by the project's `.gitignore`. Read the script before running it. If PowerShell blocks a trusted script, the existing README explains temporary process-scope execution policy.

## Interpret the result

| Status | Default rule | Next step |
| --- | --- | --- |
| Critical | Less than 5% free | Check available space and business impact promptly |
| Low | At least 5% but less than 10% free | Review storage use with the user |
| OK | At least 10% free | Meets this lab's percentage threshold; investigate other symptoms as needed |
| Unknown | Missing or invalid disk metadata | Verify access and disk information; do not assume the disk is healthy |

Values labelled GiB use 1,073,741,824 bytes per unit. Classification uses the unrounded percentage; the displayed value is rounded to two decimal places. The thresholds are configurable lab choices, not a Microsoft standard. Free percentage alone cannot establish whether a device has enough space for a particular update or workload.

```powershell
.\scripts\Get-DiskSpaceCheck.ps1 -LowSpacePercent 15 -CriticalSpacePercent 5
```

The critical threshold must be smaller than the low threshold. Query failures stop the script rather than producing an apparently successful empty report.

## Helpdesk follow-up

1. Ask whether slow performance, failed updates, or storage warnings prompted the check.
2. Review Windows Storage settings and large files with the owner.
3. Obtain agreement before removing files or uninstalling apps. Check backups and cloud-sync status first.
4. Re-run the live checker and compare available space.
5. Record actual observations and user confirmation; escalate if space drops again or the issue persists.

Low space is a finding, not proof of the cause of a slow computer. A drive marked OK may still have another issue.

## Validation record

Local Windows validation completed on 14 October 2026. Console screenshots showed the following results:

| Mode | Drive | Total GiB | Free GiB | Free % | Status |
| --- | --- | --- | --- | --- | --- |
| Demo (fictional) | C: | 100 | 35 | 35 | OK |
| Demo (fictional) | D: | 100 | 8 | 8 | Low |
| Demo (fictional) | E: | 100 | 3 | 3 | Critical |
| Live (personal device) | C: | 131.14 | 36.79 | 28.06 | OK |
| Live (personal device) | D: | 106.73 | 7.98 | 7.48 | Low |

Both runs displayed a saved CSV report path without an error. CSV contents were not independently inspected. These observations validate the displayed classifications for these inputs, not every edge case. No cleanup was performed; the live D: drive's low-space finding remains open. Review reports and remove identifying local paths from screenshots before public sharing.

## References

- [Microsoft: Win32_LogicalDisk](https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-logicaldisk)
- [Microsoft: Export-Csv](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv)
