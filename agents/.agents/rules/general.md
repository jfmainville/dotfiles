# General Coding Rules

Apply to every language, then `~/.agents/rules/<language>.md` per file touched (`lua`, `python`, `typescript` for JS/TS, `scss` for CSS, `shell`, `terraform`, `ansible`, `go`). The project's own `AGENTS.md`/`CLAUDE.md`, tool configs, and existing code win when they disagree.

## Project Instructions

- Never edit the project's `CLAUDE.md` or `AGENTS.md` to record your changes. Only edit them when the user asks, or when a change makes a line false, and then change only that line.

## Versions

- Find the supported versions first (`requires-python`, `engines`, `.nvmrc`, `browserslist`, `tsconfig.json` `target`, `go.mod`, `required_version`, `.tool-versions`, `mise.toml`, CI matrix). If none, target the oldest version still supported upstream.
- Use the newest stable features all supported versions allow, never newer. No experimental or preview features unless the project already uses them or the user asks.
- Replace deprecated APIs and outdated idioms in code you touch.

## Simplicity and Reuse

- Write the simplest code that fully meets the requirements. No abstraction, configuration, or generalization nobody asked for.
- Add a function only when it is reused or clearly improves readability. Inline one-off helpers.
- Before adding a function, component, style, constant, or type, search the codebase and its dependencies for one that does the job. Extend a near fit with a parameter or variant instead of copying it. Put shared code in the project's shared location.
- For non-trivial logic (dates, parsing, validation, retries, HTTP, UI widgets), use an existing dependency, the language file's preferred package, or a maintained package with at least 1,000 GitHub stars (`gh api repos/<owner>/<repo> -q .stargazers_count`). Not for what a few lines or the standard library handle.

## Clean Up What You Touch

- In files you change, merge duplicates and delete dead code (unused functions, imports, variables, types, styles, unreachable branches, stale flags).
- Search the whole codebase first, including dynamic references (string lookups, templates, config, routes, exports). Keep it if unsure. Stay within your area.

## Comments

- Comment only what the code can't make clear (a workaround or business rule), in one line. Never restate the code or leave commented-out code.

## Formatting and Linting

- Never hand-format against the formatter.
- Before committing, from the repository root, run on every changed file:

  ```bash
  nvim --headless -c "luafile ~/.agents/scripts/nvim-check.lua" <files>
  ```

  It formats with the user's Neovim formatters and prints LSP issues as `file:line:col: severity [source code] message`, exiting `1` when any exist. Fix the issues you introduced and rerun until only pre-existing ones remain.

- Without `nvim`, use the language file's format and lint commands. Type-checks and tests always use the language file's commands or the project's scripts.
