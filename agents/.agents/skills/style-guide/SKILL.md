---
name: style-guide
description: Generate or update a language coding rules file in `~/.agents/rules/` - takes a language and optional repository paths, learns the conventions already used in that code, drops what the formatter and linter already enforce, fills gaps from a well-known style guide, and writes a short rules file that the work-on, pr-review, pr-resolve-review, and tester skills follow. Use when the user says things like "style-guide python", "generate the Go rules", "update the TypeScript rules from ~/projects/app", or "add coding rules for a new language".
license: MIT
argument-hint: <language> [repository paths...]
metadata:
  author: jfmainville
  version: "1.1.0"
  homepage: https://github.com/jfmainville/dotfiles
---

Generate or update the coding rules for one language. The rules are read by path from `~/.agents/rules/` by every skill and harness, so keep them short, concrete, and true to how the user already writes code.

## Step 1: Parse Arguments

The user invoked this with: $ARGUMENTS

- **language** (required): the language to write rules for, e.g. `python`, `typescript`, `go`. If it is missing, stop and ask for it.
- **repository paths** (optional): local repositories to learn conventions from. If none are given, use the current repository, plus `~/dotfiles` when the language appears there.

The rules file is `~/.agents/rules/<language>.md`, all lowercase (e.g. `typescript.md` covers TypeScript and JavaScript). Resolve `~/.agents` to its real path (`readlink -f ~/.agents`) so the file lands in the dotfiles repository.

## Step 2: Read What Already Exists

- Read `~/.agents/rules/general.md` and every existing language file. Never repeat a rule from `general.md`, and match the existing files' section layout.
- If `<language>.md` already exists, this is an update: keep every rule that is still true, and only add, change, or remove rules based on what you find in Step 3.

## Step 3: Learn the Conventions

**Tool configs.** Find the formatter, linter, type-checker, and test runner for the language in the given repositories (e.g. `pyproject.toml`, `ruff.toml`, `.eslintrc*`, `eslint.config.*`, `.prettierrc*`, `stylua.toml`, `.tflint.hcl`, `package.json` scripts, CI workflows) and in `~/dotfiles/nvim/.config/nvim/lua/plugins/conform.lua` and `mason.lua`. Anything a tool already enforces does not become a written rule: list the tool in **Tooling** instead.

**Code.** Read a representative sample of each repository's source and test files in the language (10 to 20 files across different areas, not just one folder). Note the conventions that are consistent across the sample: naming, module layout, error handling, typing, logging, dependencies used for common needs, and test structure. A convention only seen in one place is not a rule.

**Base guide.** For gaps the code doesn't settle, use the language's best-known style guide (e.g. PEP 8 for Python, the Google style guides, Effective Go). Only add a rule from it when it is concrete and checkable.

**Preferred packages.** For each common need you found (HTTP, validation, dates, CLI, testing), list the package the code already uses. Check that each one has at least 1,000 GitHub stars (`gh api repos/<owner>/<repo> -q .stargazers_count`) before listing it.

## Step 4: Write the Rules File

Use this layout, leaving out sections with nothing to say:

```markdown
---
paths: ["**/*.<extension>"]
---

# <Language> Rules

Apply after `~/.agents/rules/general.md`.

## Tooling

| Task       | Command |
| ---------- | ------- |
| Format     | ...     |
| Lint       | ...     |
| Type-check | ...     |
| Test       | ...     |

## Conventions

## Preferred Packages

| Need | Package |
| ---- | ------- |

## Testing

## Avoid
```

- The `paths` header lists every file extension of the language. It lets Claude Code load the file on its own; other harnesses ignore it.
- Each rule is one line, concrete, and checkable by a reviewer. No explanations of why, no examples longer than one inline snippet.
- Keep the file under 80 lines: it is loaded into the agent's context.

## Step 5: Register a New Language

When the file is new, add the language to the table in `~/.agents/rules/general.md` and in `~/.agents/AGENTS.md`, and add the file name to the list of rules files in the `work-on`, `pr-review`, `pr-resolve-review`, and `tester` skills in `~/.agents/skills/`.

When the language's linter isn't set up in Neovim yet, tell the user which tool to add to `~/dotfiles/nvim/.config/nvim/lua/plugins/mason.lua` instead of changing it.

## Step 6: Report

Before reporting, run the Neovim format and lint check from the **Formatting and Linting** section of `~/.agents/rules/general.md` (`nvim --headless -c "luafile ~/.agents/scripts/nvim-check.lua" <files>`), or the language file's formatter and linter when Neovim isn't available, on every file you changed.

Do not commit. Show the user:

- The rules file path, and whether it was created or updated.
- The rules added, changed, or removed, each with where it came from (`repo/file`, tool config, or base guide).
- Conventions that were inconsistent across the sample and were left out, so the user can decide.
