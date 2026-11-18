# General Coding Rules

Apply these rules to every language, then the language file for each file you touch (`~/.agents/rules/<language>.md`). The project's own `AGENTS.md`/`CLAUDE.md`, tool configs, and existing code win over these files when they disagree.

| Language              | Rules file      | Applies to                                         |
| --------------------- | --------------- | -------------------------------------------------- |
| Lua                   | `lua.md`        | `*.lua`                                            |
| Python                | `python.md`     | `*.py`                                             |
| TypeScript/JavaScript | `typescript.md` | `*.ts`, `*.tsx`, `*.js`, `*.jsx`, `*.mjs`, `*.cjs` |
| SCSS/CSS              | `scss.md`       | `*.scss`, `*.css`                                  |
| Shell                 | `shell.md`      | `*.sh`, `*.bash`, `*.zsh`, `.zshrc`                |
| Terraform             | `terraform.md`  | `*.tf`, `*.tfvars`, `*.hcl`                        |
| Go                    | `go.md`         | `*.go`, `go.mod`                                   |

## Simplicity

- Implement the simplest solution that fully meets the requirements. Prefer plain, direct code over abstractions, indirection, configuration, or generalization nobody asked for.
- Don't add a function unless it is reused or makes the code clearly easier to read. Inline one-off helpers.

## Don't Reinvent the Wheel

- Before writing non-trivial logic (date handling, parsing, validation, retries, HTTP clients, UI widgets), check the project's existing dependencies, then popular, actively maintained packages.
- Only add a new package if its GitHub repository has at least 1,000 stars (`gh api repos/<owner>/<repo> -q .stargazers_count`). Don't add one for something a few lines of code or the standard library already handles.
- Each language file lists preferred packages. Use them unless the project already uses an alternative.

## Reuse Before Writing

- Before adding any function, component, style, constant, or type, search the codebase and its dependencies for one that already does the job, and use it.
- If an existing one almost fits, extend it with a parameter, prop, or variant instead of copying it.
- When something new is needed in more than one place, put it in the project's shared location (e.g. `utils/`, `components/`, `shared/`).

## Clean Up What You Touch

- In the files you change, merge duplicated code into one shared version and delete dead code: unused functions, imports, variables, types, styles, unreachable branches, and stale feature flags.
- Before deleting anything, search the whole codebase for references, including dynamic ones (string lookups, templates, config, routes, exports used by other packages). Keep it if you can't confirm it's unused.
- Stay within the area you're working in rather than cleaning up the whole repo.

## Comments

- Only comment when the code can't be made clear on its own (a non-obvious workaround or business rule). A comment is never more than one line.
- Never comment what the code already says, and never leave commented-out code.

## Formatting and Linting

- Formatting is the formatter's job: never hand-format against it.
- Before committing, format and lint every file you changed through Neovim when `nvim` and `~/.agents/scripts/nvim-check.lua` exist, from the repository root:

  ```bash
  nvim --headless -c "luafile ~/.agents/scripts/nvim-check.lua" <changed files>
  ```

  It formats and saves each file with the user's Neovim formatters, then prints the language servers' errors, warnings, and info as `file:line:col: severity [source code] message`, and exits with `1` when there are any. Fix every issue you introduced, then run it again until it passes or only issues that were already there remain. It uses the project's own formatter and linter configs when they exist.

- When Neovim isn't available, run the formatter and linter commands from the language file instead.
- Type-checks and tests always run through the commands in the language file or the project's own scripts, since Neovim only checks the files it opens.
