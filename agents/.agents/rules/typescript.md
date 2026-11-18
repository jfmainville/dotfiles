---
paths: ["**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx", "**/*.mjs", "**/*.cjs"]
---

# TypeScript and JavaScript Rules

Apply after `~/.agents/rules/general.md`.

## Tooling

| Task       | Command                                               |
| ---------- | ----------------------------------------------------- |
| Format     | `npx prettier --write <files>`                        |
| Lint       | `npx eslint <files>` with the project's config        |
| Type-check | `npx tsc --noEmit`                                    |
| Test       | The project's runner (`npx vitest run` or `npx jest`) |

Prefer the project's `package.json` scripts (`npm run lint`, `npm test`) when they exist.

## Conventions

- Write TypeScript for new code in a TypeScript project, with `strict` types.
- Never use `any`. Use `unknown` and narrow it, or a precise type.
- Names are `camelCase` for variables and functions, `PascalCase` for types, classes, and components, `UPPER_SNAKE_CASE` for constants.
- Use `const` by default, `let` only when reassigned, never `var`.
- Use `async`/`await` instead of `.then()` chains, and handle every rejected promise.
- Prefer named exports over default exports, except where the framework requires a default (e.g. Next.js pages).
- Validate external input (API responses, forms, env) at the boundary with a schema.

## React

- Function components and hooks only.
- One component per file, named after the component.
- Derive values during render instead of syncing them with `useEffect`.

## Preferred Packages

| Need                  | Package                                                               |
| --------------------- | --------------------------------------------------------------------- |
| Validation            | `zod`                                                                 |
| Dates                 | `date-fns`                                                            |
| Data fetching (React) | `@tanstack/react-query`                                               |
| Forms (React)         | `react-hook-form`                                                     |
| Testing               | `vitest` (or `jest` if the project uses it), `@testing-library/react` |

## Testing

- Test files sit next to the code or in `__tests__/`, named `<name>.test.ts(x)`.
- Test behavior through the public API or rendered output, not internal state.
- Query the DOM by role or label (`getByRole`) before test IDs.

## Avoid

- Non-null assertions (`!`) and `as` casts to silence the type-checker.
- `// @ts-ignore` and `eslint-disable` without a one-line reason.
- `dangerouslySetInnerHTML` on untrusted content.
