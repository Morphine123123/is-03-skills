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
$originRef = "origin/$BaseBranch"
& git rev-parse --verify --quiet $resolvedBase | Out-Null
if ($LASTEXITCODE -ne 0) {
  & git rev-parse --verify --quiet $originRef | Out-Null
  if ($LASTEXITCODE -eq 0) {
    $resolvedBase = $originRef
  } else {
    Write-Error "Base branch '$BaseBranch' not found locally or on origin."
    exit 1
  }
}

# If reviewing local commits on the base branch itself (e.g. on main),
# compare against origin/<base> to include local ahead commits.
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($currentBranch -eq $BaseBranch -and $resolvedBase -eq $BaseBranch) {
  & git rev-parse --verify --quiet $originRef | Out-Null
  if ($LASTEXITCODE -eq 0) {
    $resolvedBase = $originRef
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
Write-Output "Commits in current branch (newest first):"
$commits = & git log --oneline "$mergeBase..HEAD"
if (-not $commits) {
  Write-Output "(none)"
} else {
  $commits | ForEach-Object { Write-Output $_ }
}
Write-Output ""
Write-Output "Changed files:"
& git diff --name-status "$mergeBase..HEAD"
Write-Output ""
Write-Output "Changed hunks (0 context):"
& git diff --unified=0 --minimal "$mergeBase..HEAD"
Write-Output ""
Write-Output "Working tree status (porcelain):"
$status = & git status --porcelain
if (-not $status) {
  Write-Output "(clean)"
} else {
  $status | ForEach-Object { Write-Output $_ }
}
Write-Output ""
Write-Output "Working tree unstaged hunks (0 context):"
$unstaged = & git diff --unified=0 --minimal
if (-not $unstaged) {
  Write-Output "(none)"
} else {
  $unstaged | ForEach-Object { Write-Output $_ }
}
Write-Output ""
Write-Output "Working tree staged hunks (0 context):"
$staged = & git diff --cached --unified=0 --minimal
if (-not $staged) {
  Write-Output "(none)"
} else {
  $staged | ForEach-Object { Write-Output $_ }
}
