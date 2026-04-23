param(
  [string]$BaseBranch = "main"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Error "git is not available in PATH."
  exit 1
}

$repoRoot = git rev-parse --show-toplevel 2>$null
if (-not $repoRoot) {
  Write-Error "Current directory is not inside a git repository."
  exit 1
}

# Ensure base branch ref can be resolved locally or via origin.
$resolvedBase = $BaseBranch
& git rev-parse --verify --quiet $resolvedBase | Out-Null
if ($LASTEXITCODE -ne 0) {
  $originRef = "origin/$BaseBranch"
  & git rev-parse --verify --quiet $originRef | Out-Null
  if ($LASTEXITCODE -eq 0) {
    $resolvedBase = $originRef
  } else {
    Write-Error "Base branch '$BaseBranch' not found locally or on origin."
    exit 1
  }
}

$mergeBase = git merge-base $resolvedBase HEAD
if (-not $mergeBase) {
  Write-Error "Failed to compute merge-base between '$resolvedBase' and HEAD."
  exit 1
}

Write-Output "Review base branch: $resolvedBase"
Write-Output "Merge base: $mergeBase"
Write-Output ""
Write-Output "Changed files:"
& git diff --name-status "$mergeBase..HEAD"
Write-Output ""
Write-Output "Changed hunks (0 context):"
& git diff --unified=0 --minimal "$mergeBase..HEAD"
