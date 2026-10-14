#Requires -Version 7.4
[CmdletBinding()]
param()
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module PSScriptAnalyzer -RequiredVersion 1.25.0
Write-Output "PSScriptAnalyzer $((Get-Module PSScriptAnalyzer).Version)"
$scriptRoot = Split-Path $PSScriptRoot -Parent
$issues = @(Invoke-ScriptAnalyzer -Path $scriptRoot -Recurse -Severity Error, Warning)
$issues | Format-Table -AutoSize
if ($issues.Count) { throw "PowerShell analysis found $($issues.Count) issues." }
Write-Output 'PowerShell script analysis passed.'
