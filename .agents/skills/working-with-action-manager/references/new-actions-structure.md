# New Actions Structure

Use this pattern when adding a new action in `packages/excalidraw/actions/`.

## Prompting guardrails

### Don't

- Don't bypass `register()` or mutate action registry manually.
- Don't invent a new action name without updating `ActionName`.
- Don't omit `captureUpdate` in returned action results.
- Don't modify app state outside the action flow (`perform()` -> action manager updater).
- Don't add `viewMode: true` unless the action is safe in view mode.
- Don't duplicate utilities already available in `@excalidraw/element` or sibling packages.
- Don't add shortcut handlers that can overlap existing `keyTest` behavior.

```ts
// Bad: not using register() and missing captureUpdate
export const actionMyNewAction = {
  name: "myNewAction",
  label: "labels.myNewAction",
  trackEvent: false,
  perform: (elements, appState) => ({
    elements,
    appState,
  }),
};

// Bad: uses name not added to ActionName union
export const actionUntrackedName = register({
  name: "totallyNewAction",
  label: "labels.totallyNewAction",
  trackEvent: false,
  perform: (elements, appState) => false,
});
```

### Do

- Do use `register({ ... })` for every action definition.
- Do ensure `name` matches an `ActionName` entry in `packages/excalidraw/actions/types.ts`.
- Do return `false` or a valid `ActionResult` with `captureUpdate` from `perform()`.
- Do keep state transitions inside `perform()` and rely on existing `@excalidraw/*` helpers.
- Do add keyboard behavior via `keyTest` only when needed and verify no shortcut conflict.
- Do export new actions from `packages/excalidraw/actions/index.ts`.
- Do add a colocated test file for behavior, predicates, and view-mode handling.

```ts
import { CaptureUpdateAction } from "@excalidraw/element";
import { register } from "./register";

export const actionMyNewAction = register({
  name: "myNewAction",
  label: "labels.myNewAction",
  trackEvent: { category: "canvas", action: "myNewAction" },
  perform: (elements, appState, value, app) => ({
    elements,
    appState: {
      ...appState,
      openDialog: null,
    },
    captureUpdate: CaptureUpdateAction.EVENTUALLY,
  }),
  predicate: (elements, appState, appProps, app) => true,
  keyTest: (event, appState, elements, app) => false,
});
```

## 1) Add action name type

Update `packages/excalidraw/actions/types.ts` and extend `ActionName`:

```ts
export type ActionName =
  // ...existing names
  | "myNewAction";
```

If the action has a shortcut and should appear in shortcut helpers, update `ShortcutName` and `shortcutMap` in `packages/excalidraw/actions/shortcuts.ts`.

## 2) Create action file

Create `packages/excalidraw/actions/actionMyNewAction.ts` (or `.tsx` if it has `PanelComponent`):

```ts
import { CaptureUpdateAction } from "@excalidraw/element";
import { register } from "./register";

export const actionMyNewAction = register({
  name: "myNewAction",
  label: "labels.myNewAction",
  trackEvent: { category: "canvas", action: "myNewAction" },
  perform: (elements, appState, value, app) => {
    // compute next state/elements
    return {
      elements,
      appState,
      captureUpdate: CaptureUpdateAction.EVENTUALLY,
    };
  },
  predicate: (elements, appState, appProps, app) => true,
  keyTest: (event, appState, elements, app) => false,
});
```

## 3) Export action

Wire the action in `packages/excalidraw/actions/index.ts`:

```ts
export { actionMyNewAction } from "./actionMyNewAction";
```

## 4) Optional panel UI

For actions with visible controls, include `PanelComponent` and use the provided `updateData()` callback. `ActionManager.renderAction()` invokes `perform()` through this callback.

## 5) Testing guidance

- Create a colocated test file: `actionMyNewAction.test.tsx`.
- Validate:
  - state/elements changes from `perform()`
  - predicate/checked behavior
  - keyboard behavior if `keyTest` is provided
  - view mode behavior (`viewMode` true/false as intended)

## Notes on execution

- `register()` appends the action to the action registry.
- `ActionManager.handleKeyDown()` cancels when multiple actions match a shortcut.
- `ActionManager.executeAction()` and `renderAction()` both pass through analytics and updater flow.
