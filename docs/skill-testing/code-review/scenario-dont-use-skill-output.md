# Scenario Output: Should Not Use Skill

## Scenario
- Intent: non-review request
- Expected: do not invoke `code-review` skill

## Agent Output Capture
I’ll review the current branch changes directly from git (without invoking the local code-review skill), then report concrete findings ordered by severity. I’m starting by inspecting the diff and recent commits.

I found no working-tree code changes except an untracked skills-lock.json, so I’m reviewing the branch commits against main to provide a meaningful code review.

No issues found in the current diff.

Open Questions / Assumptions
I’m assuming you want review of the current local state.
Right now there are no tracked modifications or commits to review against main.
The only change present is an untracked skills-lock.json, which is valid JSON and structurally looks fine.
Change Context
git diff and git diff main...HEAD are both empty.
git log main...HEAD is empty (no branch commits ahead of main).
Untracked file: skills-lock.json.
If you want, I can review a specific commit/PR range (for example main..3061ade) or review the previous deleted/modified files if you re-stage them.

Review against last master commit on remote

I’ll compare your current HEAD against origin/master (latest remote master commit), inspect the full diff, and then provide findings by severity. I’m fetching remote refs first so the comparison is accurate.

origin/master doesn’t exist in this repo, so I’m checking which remote branch is the actual default and will review against the latest commit there (likely origin/main).

I confirmed there are two commits ahead of remote main; next I’m inspecting the PowerShell script and guidance files for functional issues and incorrect instructions.

Findings
No functional issues found in the changes between HEAD and the latest remote default-branch commit (origin/main), which is fcd3313.
Open questions / assumptions
origin/master does not exist in this repository; remote HEAD points to origin/main, so I reviewed against that commit as the remote equivalent of “last master commit.”
Review scope is 2 commits ahead of remote (9dac279, 3061ade) touching skill docs plus find-changed-parts.ps1.
I did not execute the PowerShell script end-to-end with multiple branch scenarios in this run; this is a static review.
Change summary
Added multiple agent skill docs and references under .agents/skills/....
Added code-review helper script find-changed-parts.ps1 that resolves base refs (local/origin), computes merge-base, and prints commit/file/hunk context.
Updated AGENTS.md skill listing to include the newly added skills.
If you want, I can do a quick dynamic validation of find-changed-parts.ps1 against a few branch cases (main, feature branch, missing base branch) and report runtime behavior.