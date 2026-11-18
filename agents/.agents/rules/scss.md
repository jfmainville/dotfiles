---
paths: ["**/*.scss", "**/*.css"]
---

# SCSS and CSS Rules

Apply after `~/.agents/rules/general.md`.

## Tooling

| Task   | Command                                                            |
| ------ | ------------------------------------------------------------------ |
| Format | `npx prettier --write <files>`                                     |
| Lint   | `npx stylelint <files>`, when the project has a `stylelint` config |

## Conventions

- Never hard-code colors, spacing, font sizes, font weights, radii, shadows, z-indexes, transitions, or breakpoints. Use the project's existing variables, mixins, and functions.
- If a value you need has no variable yet, add one to the existing variables file and use it instead of the raw value.
- Use `@use` instead of `@import`.
- Keep nesting to three levels or fewer, and keep selectors as flat as the project allows.
- Follow the project's naming scheme (BEM, CSS Modules, or utility classes). Don't mix schemes in one file.
- Use media query mixins for breakpoints instead of raw `@media` values.
- Use `rem` for font sizes and spacing unless the project uses another unit.

## Avoid

- `!important`, except to override third-party styles, with a one-line reason.
- ID selectors for styling.
- Inline styles where the project uses classes or utilities.
- New classes that duplicate an existing class, utility, or mixin.
