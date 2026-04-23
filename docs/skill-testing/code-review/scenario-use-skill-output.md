# Scenario Output: Should Use Skill

## Scenario
- Intent: review request
- Expected: invoke `code-review` skill

## Agent Output Capture
Reviewing the current branch changes now with a bug/regression-focused pass. I’ll first load the required review skill instructions, then inspect the diff against the default base and report findings by severity.

I’ve loaded the review workflow and project rules; next I’m collecting the exact changed hunks against main and then I’ll inspect each for regressions and test gaps.

Findings
🟡 [medium risk] .agents/skills/code-review/scripts/find-changed-parts.ps1 only diffs "$mergeBase..HEAD", so it excludes unstaged/staged/untracked working-tree changes; for prompts like “review changes,” this can miss real modifications and produce incomplete reviews. Fix by including git status --porcelain output (and optionally an extra git diff/git diff --cached) in the script output, or by updating the skill contract to clearly scope to committed changes only.
🟢 [low risk] .agents/skills/creating-component-with-tdd/SKILL.md contains a duplicated “Do not force TDD scaffolding...” block, which adds noise and can cause instruction drift during maintenance. Fix by removing one duplicate block.
Open questions / assumptions
Assumed your intent was a branch-level review against main (per the skill default), not a review of uncommitted local edits.
There is an untracked skills-lock.json in the working tree that is not part of the branch diff reviewed here.
Change summary
Branch main is 2 commits ahead of origin/main, adding multiple new skill docs and a PowerShell helper script for review scoping.
Main residual risk is review coverage ambiguity: committed-history review is solid, but local working-tree changes can be silently skipped unless the script/skill explicitly includes them.

