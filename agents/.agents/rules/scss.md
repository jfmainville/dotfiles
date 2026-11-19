---
paths: ["**/*.scss", "**/*.css"]
---

# SCSS and CSS Rules

## Tooling

| Task   | Command                                                            |
| ------ | ------------------------------------------------------------------ |
| Format | `npx prettier --write <files>`                                     |
| Lint   | `npx stylelint <files>`, when the project has a `stylelint` config |

## Versions and Modern Features

- Target Dart Sass (LibSass and `node-sass` are deprecated) and the project's `browserslist`, otherwise browser features that are Baseline "Widely available" on MDN.
- Use `@use` and `@forward` instead of `@import`, `math.div` instead of `/` for division, and the `sass:color` and `sass:map` modules (`color.adjust`, `color.scale`, `map.get`) instead of global functions like `darken` and `map-get`.
- Use modern CSS: custom properties for runtime theming, `gap` in flexbox, `clamp()`, logical properties (`margin-inline`, `inset`), `aspect-ratio`, `:is()`, `:where()`, `:focus-visible`, and container queries.
- Check `:has()` and native CSS nesting against the targets before using them.

## Conventions

- Never hard-code colors, spacing, font sizes, font weights, radii, shadows, z-indexes, transitions, or breakpoints. Use the project's existing variables, mixins, and functions.
- If a value you need has no variable yet, add one to the existing variables file and use it instead of the raw value.
- Keep nesting to three levels or fewer, and keep selectors as flat as the project allows.
- Follow the project's naming scheme (BEM, CSS Modules, or utility classes). Don't mix schemes in one file.
- Use media query mixins for breakpoints instead of raw `@media` values.
- Use `rem` for font sizes and spacing unless the project uses another unit.

## Avoid

- `!important`, except to override third-party styles, with a one-line reason.
- ID selectors for styling.
- Inline styles where the project uses classes or utilities.
- New classes that duplicate an existing class, utility, or mixin.
