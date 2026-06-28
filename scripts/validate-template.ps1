Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
$Utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$Utf8Strict = [System.Text.UTF8Encoding]::new($false, $true)
$PurposePlaceholder = "[" + [string][char]0x7528 + [string][char]0x9014 + [string][char]0x3092 + [string][char]0x66F8 + [string][char]0x304F + "]"
[Console]::OutputEncoding = $Utf8NoBom
$OutputEncoding = $Utf8NoBom

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $scriptRoot
$failures = New-Object System.Collections.Generic.List[string]

function Add-Failure {
  param([string]$Message)
  $failures.Add($Message) | Out-Null
}

function Read-Utf8Strict {
  param([Parameter(Mandatory = $true)][string]$Path)
  return [System.IO.File]::ReadAllText($Path, $Utf8Strict)
}

$requiredFiles = @(
  "README.md",
  "START_HERE.md",
  "AGENTS.md",
  "CLAUDE.md",
  "setup-decision-guide.md",
  "daily-use-minimal-kit.md",
  "scaffold/README.md",
  "scaffold/AI_ORG/MANIFEST.md",
  "scaffold/AI_ORG/orchestrator.md",
  "scaffold/AI_ORG/Agents/worker.md",
  "scaffold/AI_ORG/Agents/critic.md",
  "scaffold/AI_ORG/Workflows/execute.md",
  "scaffold/AI_ORG/Runtime/BOOT.md",
  "scaffold/AI_ORG/Runtime/CONTEXT_INDEX.md",
  "scaffold/AI_ORG/Runtime/OBSERVATIONS.md",
  "scaffold/AI_ORG/Runtime/HEALTH.md",
  "scaffold/AI_ORG/Scratch/README.md",
  "scaffold/AI_ORG/Reports/dispatch-trace.md",
  "scaffold/AI_ORG/Reports/health-check.md",
  "scaffold/AI_ORG/Decisions/ADR-template.md",
  "scaffold/AI_ORG/Vault/README.md",
  "scripts/init-ai-org.ps1",
  "scripts/init-ai-org.sh",
  "scripts/validate-template.ps1",
  "scripts/validate-template.sh"
)

foreach ($relative in $requiredFiles) {
  $path = Join-Path $root $relative
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    Add-Failure "Missing required file: $relative"
  }
  elseif ((Get-Item -LiteralPath $path).Length -eq 0) {
    Add-Failure "Required file is empty: $relative"
  }
}

$markdownFiles = Get-ChildItem -LiteralPath $root -Recurse -File -Filter "*.md" |
  Where-Object { $_.FullName -notmatch "\\.git\\" }

foreach ($file in $markdownFiles) {
  $relative = $file.FullName.Substring($root.Length + 1)
  try {
    $content = Read-Utf8Strict -Path $file.FullName
  } catch {
    Add-Failure "Invalid UTF-8: $relative ($($_.Exception.Message))"
    continue
  }

  $matches = [regex]::Matches($content, "\[[^\]]+\]\(([^)\s]+)(?:\s+""[^""]*"")?\)")
  foreach ($match in $matches) {
    $target = $match.Groups[1].Value
    if ($target.StartsWith("#") -or $target -match "^[a-zA-Z][a-zA-Z0-9+.-]*:") {
      continue
    }
    $targetPath = ($target -split "#")[0]
    if ([string]::IsNullOrWhiteSpace($targetPath)) {
      continue
    }
    $combined = Join-Path $file.DirectoryName $targetPath
    if (-not (Test-Path -LiteralPath $combined)) {
      Add-Failure "Broken markdown link in ${relative}: $target"
    }
  }
}

$agentsPath = Join-Path $root "AGENTS.md"
$claudePath = Join-Path $root "CLAUDE.md"
if ((Test-Path -LiteralPath $agentsPath) -and (Test-Path -LiteralPath $claudePath)) {
  $agents = Read-Utf8Strict -Path $agentsPath
  $claude = Read-Utf8Strict -Path $claudePath
  $normalizedClaude = $claude -replace "# CLAUDE.md", "# AGENTS.md"
  if ($agents -ne $normalizedClaude) {
    Add-Failure "AGENTS.md and CLAUDE.md are out of sync except for the heading."
  }
}

$manifestPath = Join-Path $root "scaffold/AI_ORG/MANIFEST.md"
if (Test-Path -LiteralPath $manifestPath) {
  $manifest = Read-Utf8Strict -Path $manifestPath
  $purposeMatches = [regex]::Matches($manifest, [regex]::Escape($PurposePlaceholder)).Count
  if ($purposeMatches -ne 1) {
    Add-Failure "scaffold/AI_ORG/MANIFEST.md must keep exactly one required purpose placeholder for initialization."
  }
  if (-not ($manifest -match "improvement_suggestions:\s*end_of_task")) {
    Add-Failure "MANIFEST default improvement_suggestions should be end_of_task."
  }
  if (-not ($manifest -match "health_check:\s*manual")) {
    Add-Failure "MANIFEST default health_check should be manual."
  }
}

$contextPath = Join-Path $root "scaffold/AI_ORG/Runtime/CONTEXT_INDEX.md"
if (Test-Path -LiteralPath $contextPath) {
  $context = Read-Utf8Strict -Path $contextPath
  if (-not ($context -match "(?m)^\[template path\]\r?$")) {
    Add-Failure "Runtime/CONTEXT_INDEX.md must keep the optional template source codeblock line."
  }
}

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-org-template-validate-" + [System.Guid]::NewGuid().ToString("N"))
try {
  New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

  $initScript = Join-Path $root "scripts/init-ai-org.ps1"
  $dryParent = Join-Path $tempRoot "dry"
  $realParent = Join-Path $tempRoot "real"
  New-Item -ItemType Directory -Force -Path $dryParent | Out-Null
  New-Item -ItemType Directory -Force -Path $realParent | Out-Null

  $dryDestination = Join-Path $dryParent "AI_ORG"
  & $initScript -Destination $dryDestination -Purpose "validation dry run" -TemplatePath $root -DryRun | Out-Null
  if (Test-Path -LiteralPath $dryDestination) {
    Add-Failure "Init dry run created a destination directory."
  }

  $realDestination = Join-Path $realParent "AI_ORG"
  & $initScript -Destination $realDestination -Purpose "validation actual copy" -TemplatePath $root | Out-Null
  if (-not (Test-Path -LiteralPath (Join-Path $realDestination "MANIFEST.md") -PathType Leaf)) {
    Add-Failure "Init copy did not produce AI_ORG/MANIFEST.md."
  }
  else {
    $copiedManifest = Read-Utf8Strict -Path (Join-Path $realDestination "MANIFEST.md")
    if ($copiedManifest.Contains($PurposePlaceholder)) {
      Add-Failure "Init copy left the required purpose placeholder in MANIFEST.md."
    }
    if (-not $copiedManifest.Contains("validation actual copy")) {
      Add-Failure "Init copy did not write the supplied purpose to MANIFEST.md."
    }
  }

  $copiedContextPath = Join-Path $realDestination "Runtime/CONTEXT_INDEX.md"
  if (Test-Path -LiteralPath $copiedContextPath -PathType Leaf) {
    $copiedContext = Read-Utf8Strict -Path $copiedContextPath
    if ($copiedContext -match "(?m)^\[template path\]\r?$") {
      Add-Failure "Init copy left the optional template source codeblock line after -TemplatePath was supplied."
    }
    if (-not $copiedContext.Contains($root)) {
      Add-Failure "Init copy did not write the supplied template path to Runtime/CONTEXT_INDEX.md."
    }
  }

  try {
    & $initScript -Destination $realDestination -Purpose "overwrite attempt" | Out-Null
    Add-Failure "Init script allowed an existing destination to be reused."
  }
  catch {
    # Expected: safe no-overwrite default.
  }
} finally {
  $resolvedTemp = Resolve-Path -LiteralPath $tempRoot -ErrorAction SilentlyContinue
  $tempBase = [System.IO.Path]::GetTempPath()
  if ($resolvedTemp -and $resolvedTemp.Path.StartsWith($tempBase, [System.StringComparison]::OrdinalIgnoreCase)) {
    Remove-Item -LiteralPath $resolvedTemp.Path -Recurse -Force
  }
}

if ($failures.Count -gt 0) {
  Write-Host "Template validation failed:"
  foreach ($failure in $failures) {
    Write-Host "  - $failure"
  }
  exit 1
}

Write-Host "Template validation passed."
