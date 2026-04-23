---
name: working-with-action-manager
description: Add or modify Excalidraw actions using the project actionManager architecture. Use when creating action files, wiring shortcuts/panels, registering actions, or changing action execution behavior in packages/excalidraw/actions.
---

# Working With Action Manager

## When to use this skill

Use when the task touches `packages/excalidraw/actions/` or `actionManager` behavior.

## Quick workflow

1. Identify whether you are adding a new action or editing an existing one.
2. For new actions, follow the file structure in [new-actions-structure.md](references/new-actions-structure.md).
3. Keep action state updates inside `perform()` and return a valid `ActionResult`.
4. Register actions by exporting from `packages/excalidraw/actions/index.ts`.
5. If adding keyboard support, define `keyTest` and update shortcut mapping when needed.
6. Add or update colocated tests in `packages/excalidraw/actions/`.

## Project-specific constraints

- Always create actions using `register({ ... })` from `packages/excalidraw/actions/register.ts`.
- `name` must be a valid `ActionName` from `packages/excalidraw/actions/types.ts`.
- `perform()` must return either `false` or an object with `captureUpdate`.
- Respect view mode:
  - Default behavior blocks actions in view mode.
  - Set `viewMode: true` only when safe.
- Use `predicate` to control availability in UI, and `keyTest` for keyboard triggers.
- Prefer existing utilities from `@excalidraw/*` packages instead of duplicating logic.

## ActionManager behavior to preserve

- Keyboard path: `ActionManager.handleKeyDown()` picks exactly one matching action.
- Execution path: `ActionManager.executeAction()` calls `perform()` and tracks analytics.
- UI path: `renderAction()` renders `PanelComponent` and calls `perform()` via `updateData`.
- Analytics are configured by `trackEvent` metadata on each action.

## Verification checklist

- Action file compiles and is exported from `actions/index.ts`.
- `ActionName` union includes the new action name.
- `trackEvent` category is set correctly or explicitly disabled (`false`).
- Shortcut behavior is not duplicated or conflicting with existing actions.
- Tests cover the main action behavior and edge cases.

## Reference

- New action authoring structure: [new-actions-structure.md](references/new-actions-structure.md)
