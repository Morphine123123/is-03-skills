---
name: code-review
description: Review code changes for bugs, regressions, security issues, and missing tests. Use when the user asks for a code review, PR review, or review of a branch/diff. If the prompt specifies a base branch, compare against that branch; otherwise default to main.
---

# Code Review

## When to use this skill

Use for requests like:

- "review this code"
- "review this PR"
- "review branch X"
- "review the diff"

## Branch selection rule

1. If the user prompt specifies a base branch, use that branch as the comparison base.
2. If no base branch is specified, default the base branch to `main`.

Examples:

- "review feature/login against {{branch}}" -> base branch is `{{branch}}`
- "review my branch" -> base branch is `main`

## Review workflow

1. Determine current branch and selected base branch.
2. Run the changed-parts script in **PowerShell** to collect exact diff scope:
   - default base: `powershell -ExecutionPolicy Bypass -File .agents/skills/code-review/scripts/find-changed-parts.ps1`
   - explicit base: `powershell -ExecutionPolicy Bypass -File .agents/skills/code-review/scripts/find-changed-parts.ps1 -BaseBranch {{branch}}`
3. Inspect changes from base branch to `HEAD`.
4. Prioritize findings by severity:
   - critical: correctness, data loss, security, crashes
   - major: behavior regressions, missing edge-case handling
   - minor: maintainability, readability, low-risk issues
5. Focus on concrete, actionable feedback with exact file/symbol references.
6. Call out test gaps and suggest high-value tests for risky changes.

## Required runtime environment

- Run the diff discovery script in **PowerShell** (Windows-first workflow).
- Do not use bash/zsh command forms for this skill's scripted step.

## Utility script

- Script: `.agents/skills/code-review/scripts/find-changed-parts.ps1`
- Purpose: resolve base branch (`main` by default), compute merge-base, print changed files and changed hunks for review targeting.

## Required review output

Return findings first, then assumptions/open questions, then a brief summary.

Use colored circle markers for fast scanning:

- 🔴 **critical severity**: must-fix issues (security, data loss, crashes)
- 🟠 **high risk**: likely regressions or fragile behavior under edge cases
- 🟡 **medium risk**: correctness gaps with limited impact
- 🟢 **low risk**: minor maintainability or clarity improvements
- 🔵 **bug found**: confirmed bug in behavior or logic (can be combined with a severity line)

Use this structure:

```markdown
## Findings
- 🔴 [critical] issue, impact, and specific fix
- 🟠 [high-risk] issue, impact, and specific fix
- 🔵 [bug] confirmed bug, user impact, and concrete fix

## Open questions / assumptions
- assumption or clarification needed

## Change summary
- short summary of what changed
- residual risk / test gaps
```

## Review quality checklist

- Compare against the correct base branch (`main` if unspecified)
- Cover correctness, security, regressions, and tests
- Use circle severity/risk/bug markers consistently in findings
- Prefer signal over volume; avoid style-only noise unless it affects safety/clarity
- Ensure each finding includes why it matters and how to fix it
