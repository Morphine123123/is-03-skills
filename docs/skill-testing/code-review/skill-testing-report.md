# Skill Testing Report: `code-review`

## Status
- Completed

## Scenario Output Files
- Use skill scenario output: `./scenario-use-skill-output.md`
- Do not use skill scenario output: `./scenario-dont-use-skill-output.md`

## Skill Metadata
- Skill name: `code-review`
- Skill path: `.agents/skills/code-review/SKILL.md`
- Skill version/date: local workspace version (tested on 2026-04-23)

## Test Matrix
- Scenario 1 (should use skill):
  - Prompt: Review changes
  - Expected behavior: Invoke `code-review` skill, compare against default base (`main`), and return severity-prioritized actionable findings.
  - Actual behavior: Agent explicitly loaded review workflow, compared branch changes against `main`, and returned findings with severity plus assumptions and summary sections.
  - Pass/Fail: Pass
  - Notes: Output followed a consistent review structure and included actionable feedback on scope gaps (working-tree changes omission) and documentation quality.
- Scenario 2 (should not use skill):
  - Prompt: Make a code review without local code-review skill
  - Expected behavior: Do not use local `code-review` skill; perform direct git-based review.
  - Actual behavior: Agent reviewed directly via git commands, explicitly stating no local skill use; then completed remote-base review against `origin/main`.
  - Pass/Fail: Pass
  - Notes: Behavior correctly respected the request constraint and still produced a structured review output.

## Checklist
- [x] Skill is invoked when review intent is explicit
- [x] Skill is not invoked for non-review requests
- [x] Base branch behavior is correct (`main` default, explicit base respected)
- [x] Output format follows skill requirements
- [x] Findings are severity-prioritized and actionable

## Additional Notes
- Using the skill helps standardize code reviews into the same pattern each time it is used.
- Using the skill results in shorter output in practice (lower output token usage) compared to a fully manual review flow.
- The non-skill flow can still be accurate, but format consistency depends more on agent behavior and prompt phrasing.
