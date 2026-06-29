param(
  [string]$Destination = "",
  [string]$Purpose = "",
  [ValidateSet("minimal", "development")]
  [string]$Preset = "minimal",
  [string]$TemplatePath = "",
  [switch]$DryRun
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
$Utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$Utf8Strict = [System.Text.UTF8Encoding]::new($false, $true)
$PurposePlaceholder = "[" + [string][char]0x7528 + [string][char]0x9014 + [string][char]0x3092 + [string][char]0x66F8 + [string][char]0x304F + "]"
[Console]::OutputEncoding = $Utf8NoBom
$OutputEncoding = $Utf8NoBom

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$templateRoot = Split-Path -Parent $scriptRoot
$source = Join-Path (Join-Path $templateRoot "scaffold") "AI_ORG"

if ([string]::IsNullOrWhiteSpace($Destination)) {
  $Destination = Join-Path (Get-Location) "AI_ORG"
}

$destinationFull = [System.IO.Path]::GetFullPath($Destination)
$sourceFull = [System.IO.Path]::GetFullPath($source)

if (-not (Test-Path -LiteralPath $sourceFull -PathType Container)) {
  throw "Template scaffold not found: $sourceFull"
}

if ([string]::IsNullOrWhiteSpace($Purpose) -and -not $DryRun) {
  if (-not [Console]::IsInputRedirected) {
    $Purpose = Read-Host "Purpose for this AI_ORG"
  }
  if ([string]::IsNullOrWhiteSpace($Purpose)) {
    throw "Purpose is required for a real initialization. Pass -Purpose or use -DryRun."
  }
}

Write-Host "AI_ORG initialization"
Write-Host "  source:      $sourceFull"
Write-Host "  destination: $destinationFull"
Write-Host "  preset:      $Preset"
if (-not [string]::IsNullOrWhiteSpace($Purpose)) {
  Write-Host "  purpose:     $Purpose"
}
if (-not [string]::IsNullOrWhiteSpace($TemplatePath)) {
  Write-Host "  template:    $TemplatePath"
}

if (Test-Path -LiteralPath $destinationFull) {
  throw "Destination already exists. Refusing to overwrite: $destinationFull"
}

if ($Preset -eq "development") {
  $overlay = Join-Path (Join-Path (Join-Path $templateRoot "presets") "development") "AI_ORG"
  if (-not (Test-Path -LiteralPath $overlay -PathType Container)) {
    throw "Development preset overlay not found: $overlay"
  }
}

$baseFiles = @(Get-ChildItem -LiteralPath $sourceFull -Recurse -File | Sort-Object FullName)
Write-Host "  base files:  $($baseFiles.Count)"
$baseRelativeSet = @{}
foreach ($file in $baseFiles) {
  $relative = $file.FullName.Substring($sourceFull.Length + 1).Replace("\", "/")
  Write-Host "    $relative"
  $baseRelativeSet[$relative.ToLowerInvariant()] = $true
}

if ($Preset -eq "development") {
  $overlayFull = [System.IO.Path]::GetFullPath($overlay)
  $overlayFiles = @(Get-ChildItem -LiteralPath $overlayFull -Recurse -File | Sort-Object FullName)
  Write-Host "  overlay files: $($overlayFiles.Count)"
  $overwrittenFiles = New-Object System.Collections.Generic.List[string]
  foreach ($file in $overlayFiles) {
    $relative = $file.FullName.Substring($overlayFull.Length + 1).Replace("\", "/")
    Write-Host "    $relative"
    if ($baseRelativeSet.ContainsKey($relative.ToLowerInvariant())) {
      $overwrittenFiles.Add($relative) | Out-Null
    }
  }
  Write-Host "  overwritten files: $($overwrittenFiles.Count)"
  foreach ($relative in $overwrittenFiles) {
    Write-Host "    $relative"
  }
}

if ($DryRun) {
  Write-Host "Dry run only. No files were written."
  exit 0
}

function Write-Utf8NoBom {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Content
  )
  [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

function Read-Utf8 {
  param([Parameter(Mandatory = $true)][string]$Path)
  return [System.IO.File]::ReadAllText($Path, $Utf8Strict)
}

function Replace-ExactLine {
  param(
    [Parameter(Mandatory = $true)][string]$Content,
    [Parameter(Mandatory = $true)][string]$Pattern,
    [Parameter(Mandatory = $true)][string]$Replacement
  )
  return [System.Text.RegularExpressions.Regex]::Replace(
    $Content,
    $Pattern,
    [System.Text.RegularExpressions.MatchEvaluator]{ param($match) $Replacement }
  )
}

Copy-Item -LiteralPath $sourceFull -Destination $destinationFull -Recurse

if ($Preset -eq "development") {
  Copy-Item -Path (Join-Path $overlay "*") -Destination $destinationFull -Recurse -Force
}

$manifestPath = Join-Path $destinationFull "MANIFEST.md"
if (-not [string]::IsNullOrWhiteSpace($Purpose) -and (Test-Path -LiteralPath $manifestPath)) {
  $content = Read-Utf8 -Path $manifestPath
  $content = $content.Replace($PurposePlaceholder, $Purpose)
  Write-Utf8NoBom -Path $manifestPath -Content $content
}

if ((Test-Path -LiteralPath $manifestPath) -and (Read-Utf8 -Path $manifestPath).Contains($PurposePlaceholder)) {
  throw "Required setup placeholder remains in copied MANIFEST.md."
}

$contextPath = Join-Path (Join-Path $destinationFull "Runtime") "CONTEXT_INDEX.md"
if (-not [string]::IsNullOrWhiteSpace($TemplatePath) -and (Test-Path -LiteralPath $contextPath)) {
  $content = Read-Utf8 -Path $contextPath
  $content = Replace-ExactLine -Content $content -Pattern "(?m)^\[template path\]\r?$" -Replacement $TemplatePath
  Write-Utf8NoBom -Path $contextPath -Content $content
}

Write-Host "Created AI_ORG:"
Get-ChildItem -LiteralPath $destinationFull -Recurse -File |
  ForEach-Object {
    $relative = $_.FullName.Substring($destinationFull.Length + 1)
    Write-Host "  $relative"
  }
