---
name: style-guide
description: Generate or update `~/.agents/rules/<language>.md` from the conventions in the given repositories, filling gaps from the language's main style guide. Use for "style-guide python" or "update the Go rules from ~/projects/app".
license: MIT
argument-hint: <language> [repository paths...]
metadata:
  author: jfmainville
  version: "2.0.0"
  homepage: https://github.com/jfmainville/dotfiles
---

Arguments: $ARGUMENTS. The language is required. The repositories default to the current one, plus `~/dotfiles` if it uses the language. Write to `$(readlink -f ~/.agents)/rules/<language>.md`, in lowercase.

## 1. Read

Read `general.md` and the existing language files. Never repeat a `general.md` rule, and match their layout. When updating, keep every rule that is still true.

## 2. Learn

- **Tools.** Find the formatter, linter, type-checker, and test runner in the repos' configs and CI and in `~/dotfiles/nvim/.config/nvim/lua/plugins/{conform,mason}.lua`. List them under **Tooling**. What a tool enforces is not a rule.
- **Code.** Sample 10 to 20 source and test files across areas. Only conventions consistent across the sample become rules.
- **Base guide.** Fill gaps with concrete, checkable rules from the language's main guide (PEP 8, Effective Go, the Google guides).
- **Versions.** Find the supported versions per `general.md` and list the newest stable features they allow, gating newer ones by version.
- **Packages.** List the package the code uses for each common need, only if it has at least 1,000 stars.

## 3. Write

```markdown
---
paths: ["**/*.<extension>"]
---

# <Language> Rules

## Tooling

| Task | Command |

## Versions and Modern Features

## Conventions

## Preferred Packages

## Testing

## Avoid
```

- Leave out empty sections. `paths` lists every extension, so Claude Code can load the file on its own.
- One concrete, checkable line per rule. No explanations, and the file stays under 60 lines.
- For a new language, add it to the language list in `general.md`. If its linter isn't in `mason.lua`, tell the user which tool to add.

## 4. Report

Run the format and lint check from `general.md` on the changed files. Don't commit. Report the path, whether it was created or updated, each added, changed, or removed rule with its source, and the inconsistent conventions you left out.
