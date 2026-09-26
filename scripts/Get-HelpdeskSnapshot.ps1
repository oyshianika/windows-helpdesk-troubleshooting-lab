# Read-only Windows support snapshot. PowerShell 5.1+.
[CmdletBinding()]
param([string]$OutputDirectory = (Join-Path $PWD 'output'))
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$report = Join-Path $OutputDirectory "helpdesk-snapshot-$timestamp.txt"
function Add-Section { param([string]$Title, [scriptblock]$Command)
  Add-Content -Path $report -Value "`r`n=== $Title ==="
  try { $result = & $Command | Out-String -Width 180; Add-Content -Path $report -Value $result }
  catch { Add-Content -Path $report -Value "Unavailable: $($_.Exception.Message)" }
}
Set-Content -Path $report -Value "Windows Help Desk Snapshot | $(Get-Date -Format s)`r`nReview before sharing: may contain device name, IP addresses, installed software and user profile details."
Add-Section 'Operating system' { Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, LastBootUpTime }
Add-Section 'Memory and CPU' { Get-CimInstance Win32_ComputerSystem | Select-Object TotalPhysicalMemory; Get-CimInstance Win32_Processor | Select-Object Name }
Add-Section 'Local disks' { Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | Select-Object DeviceID, Size, FreeSpace }
Add-Section 'Network adapters' { Get-NetAdapter | Select-Object Name, Status, LinkSpeed }
Add-Section 'IP configuration' { Get-NetIPConfiguration | Select-Object InterfaceAlias, IPv4Address, IPv4DefaultGateway, DNSServer }
Add-Section 'DNS resolution' { Resolve-DnsName example.com -Type A | Select-Object Name, Type, IPAddress }
Add-Section 'Internet reachability (HTTPS TCP)' { Test-NetConnection example.com -Port 443 -InformationLevel Quiet }
Add-Section 'Recent system errors (max 10)' { Get-WinEvent -FilterHashtable @{LogName='System'; Level=2; StartTime=(Get-Date).AddDays(-1)} -MaxEvents 10 | Select-Object TimeCreated, ProviderName, Id, Message }
Write-Host "Saved report: $report"
Write-Host 'Review and redact personal or organization details before sharing.'
