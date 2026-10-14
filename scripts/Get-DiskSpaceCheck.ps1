#requires -Version 5.1
<#
.SYNOPSIS
Reports fixed-drive free space and exports a CSV for helpdesk triage.
.DESCRIPTION
Reads disk metadata; writes only its report. Does not delete files or change settings.
Thresholds are lab defaults, not a Microsoft standard or a diagnosis of PC slowness.
Use -Demo to see fictional results without querying Windows disks.
#>
[CmdletBinding()]
param(
    [ValidateRange(1, 100)]
    [double]$LowSpacePercent = 10,
    [ValidateRange(0, 100)]
    [double]$CriticalSpacePercent = 5,
    [string]$OutputDirectory = (Join-Path (Split-Path $PSScriptRoot -Parent) 'output'),
    [switch]$Demo
)

$ErrorActionPreference = 'Stop'
if ($CriticalSpacePercent -ge $LowSpacePercent) {
    throw 'CriticalSpacePercent must be smaller than LowSpacePercent.'
}

if ($Demo) {
    $disks = @(
        [pscustomobject]@{ DeviceID = 'C:'; Size = 100GB; FreeSpace = 35GB }
        [pscustomobject]@{ DeviceID = 'D:'; Size = 100GB; FreeSpace = 8GB }
        [pscustomobject]@{ DeviceID = 'E:'; Size = 100GB; FreeSpace = 3GB }
    )
    $mode = 'Demo'
} else {
    if ($env:OS -ne 'Windows_NT') {
        throw 'Live mode requires Windows. Use -Demo for fictional data.'
    }
    $disks = @(Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3')
    $mode = 'Live'
}
if ($disks.Count -eq 0) {
    throw 'No fixed drives were returned; no report was created.'
}

$results = @(foreach ($disk in $disks) {
    $total = $null
    $free = $null
    $percent = $null
    $status = 'Unknown'
    if ($null -ne $disk.Size -and $null -ne $disk.FreeSpace -and
        $disk.Size -gt 0 -and $disk.FreeSpace -ge 0 -and $disk.FreeSpace -le $disk.Size) {
        $rawPercent = 100.0 * $disk.FreeSpace / $disk.Size
        $total = [math]::Round($disk.Size / 1GB, 2)
        $free = [math]::Round($disk.FreeSpace / 1GB, 2)
        $percent = [math]::Round($rawPercent, 2)
        if ($rawPercent -lt $CriticalSpacePercent) { $status = 'Critical' }
        elseif ($rawPercent -lt $LowSpacePercent) { $status = 'Low' }
        else { $status = 'OK' }
    }
    [pscustomobject]@{
        Drive = $disk.DeviceID
        TotalGiB = $total
        FreeGiB = $free
        FreePercent = $percent
        Status = $status
        Mode = $mode
    }
})

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
$report = Join-Path $OutputDirectory "disk-space-$mode-$timestamp.csv"
$results | Export-Csv -LiteralPath $report -NoTypeInformation -Encoding UTF8
$results | Format-Table -AutoSize | Out-Host
Write-Host "Saved report: $report"
Write-Host 'Low/Critical flags call for investigation. This script does not perform cleanup.'




