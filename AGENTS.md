# AGENTS.md

## Project Overview

Excalidraw is an open-source, collaborative virtual whiteboard for sketching hand-drawn-like diagrams. Built with React and TypeScript, it uses a custom Canvas 2D rendering engine and custom state management via `actionManager`.

## Tech Stack

- **Language**: TypeScript (strict mode)
- **UI**: React 19 (functional components, hooks only)
- **Build**: Vite
- **Testing**: Vitest + React Testing Library
- **Package Manager**: Yarn 1.x with workspaces
- **Linting**: ESLint + Prettier

## Project Structure

```
excalidraw-monorepo/
├── excalidraw-app/        # Vite-based web application
├── packages/
│   ├── excalidraw/        # Core library (@excalidraw/excalidraw)
│   │   ├── components/    # React UI components
│   │   ├── actions/       # State actions (actionManager)
│   │   ├── renderer/      # Canvas rendering pipeline
│   │   ├── scene/         # Scene management
│   │   └── types.ts       # Core type definitions (AppState)
│   ├── math/              # Math utilities (points, angles, vectors)
│   ├── element/           # Element types and operations
│   ├── common/            # Shared utilities
│   └── utils/             # General utilities
├── examples/              # Usage examples (Next.js, browser script)
└── dev-docs/              # Developer documentation
```

## Key Commands

- `yarn` — install dependencies
- `yarn start` — start dev server (excalidraw-app)
- `yarn build` — build the app
- `yarn test:app` — run Vitest tests
- `yarn test:typecheck` — TypeScript type checking
- `yarn test:code` — ESLint
- `yarn test:other` — Prettier check
- `yarn test:all` — run all checks
- `yarn fix` — auto-fix linting and formatting

## Architecture

- **State Management**: custom `actionManager` (NOT Redux/Zustand/MobX). State updates via `actionManager.dispatch()` only. State type: `AppState` in `packages/excalidraw/types.ts`.
- **Rendering**: Canvas 2D rendering via custom engine (NOT React DOM for drawing). Pipeline: Scene -> `renderScene()` -> canvas 2D context.
- **Monorepo**: Yarn workspaces with `@excalidraw/*` package aliases defined in `tsconfig.json`.

## Conventions

- Functional components with hooks only (no class components)
- Named exports only (no default exports)
- Props type: `{ComponentName}Props`
- Colocated tests: `ComponentName.test.tsx`
- TypeScript strict mode — no `any`, no `@ts-ignore`
- SCSS modules or CSS custom properties for styling
- kebab-case for utility files, PascalCase for components

## Skills

<!-- Add your Agent Skills here during the workshop -->

Available skills in this project:

- **creating-excalidraw-components** (`.agents/skills/`) — Create React components following Excalidraw's patterns and conventions
- **creating-component-with-tdd** (`.agents/skills/`) — Create components with strict test-first TDD only when explicitly requested; falls back to default component flow when use cases are missing
- **working-with-action-manager** (`.agents/skills/`) — Add and modify actions using Excalidraw's `actionManager` patterns, registration flow, and shortcut wiring
- **code-review** (`.agents/skills/`) — Review branch or diff changes for bugs, regressions, and test gaps; uses prompt-specified base branch or defaults to `main`
