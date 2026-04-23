---
name: creating-component-with-tdd
description: Create React components using strict test-first TDD in Excalidraw. Use only when the user explicitly asks for TDD or test-first implementation for a new component. If no use cases are provided, follow the default component creation workflow instead.
---

# Creating Component With TDD

## When to use this skill

Use this skill only when both are true:

1. The task is creating or adding a React component.
2. The user explicitly requests TDD or test-first workflow.

If either condition is false, do not use this skill.

## Trigger guard

Before writing files, check for explicit TDD intent:

- Valid trigger examples: "use TDD", "test first", "write tests first", "follow TDD".
- If no explicit TDD trigger appears, use `creating-excalidraw-components` flow.

## Required order of execution

Never implement component code before tests.

1. Gather use cases from the prompt.
2. Create component test spec first with all identified use cases.
3. Run tests and confirm they fail for expected reasons.
4. Implement the component to satisfy tests.
5. Re-run tests and iterate until passing.

## Use case handling

### Case A: Use cases are provided

1. Extract all explicit behaviors from the user request.
2. Convert each behavior into at least one test scenario.
3. Add edge-case and error-state tests implied by the behavior.
4. Write the test file first: `packages/excalidraw/components/{ComponentName}.test.tsx`.
5. Ensure tests cover:
   - render and accessibility basics
   - props-driven behavior
   - interaction states (if interactive)
   - disabled/empty/loading/error states where relevant

### Case B: No use cases are provided

Inform the user:  
"No use cases or scenarios were provided, so defaulting to the standard component creation flow."

Do not force TDD scaffolding. Fall back to the default component flow:

- Use `creating-excalidraw-components`.
- Follow its standard implementation and baseline testing guidance.

## Implementation constraints after tests

When moving from failing tests to implementation:

- Create component in `packages/excalidraw/components/{ComponentName}.tsx`.
- Use functional components with hooks only.
- Use named exports only.
- Use `{ComponentName}Props` type.
- Follow Excalidraw styling and architecture constraints.

## Validation checklist

- [ ] TDD was explicitly requested.
- [ ] All provided use cases are represented in tests.
- [ ] Test spec was created before component implementation.
- [ ] Tests failed before implementation.
- [ ] Component implementation was written only after failing tests.
- [ ] Final tests pass.
- [ ] Tests were run with coverage and uncovered code was reviewed.

## Coverage pruning rule

After tests pass, run coverage and trim untested implementation paths:

1. Run the component test suite with coverage enabled.
2. Identify component code paths not exercised by tests.
3. Remove untested code paths that are not required by explicit use cases.
4. Re-run tests.

If tests still pass:

- Keep the removal (the code was unnecessary or dead).

If tests fail after removal:

- Restore the removed code.
- Flag that code as "magic" code (behavior not captured clearly by tests).
- Ask the user to review and refine test cases for that behavior before continuing.

## Output expectations

When reporting work:

1. List interpreted use cases.
2. List test scenarios added first.
3. Confirm red-green cycle (failed first, then passed).
4. Summarize coverage results and any code removed.
5. If "magic" code was detected, call it out and request user review of affected test cases.
