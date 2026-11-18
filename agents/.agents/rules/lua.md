---
paths: ["**/*.lua"]
---

# Lua Rules

Apply after `~/.agents/rules/general.md`.

## Tooling

| Task                | Command                                                             |
| ------------------- | ------------------------------------------------------------------- |
| Format              | `stylua <files>` (tabs, 120 columns, double quotes by default)      |
| Lint and type-check | `lua-language-server --check <dir>`                                 |
| Test                | `busted` or `nvim -l` scripts, only if the project already has them |

## Conventions

- Declare everything `local`. Never create globals, except Neovim's `vim` global.
- A module is a file that returns one table. Require it by path (`require("plugins.oil")`), never through globals.
- Names are `snake_case` for variables and functions, `PascalCase` only for classes built with metatables.
- Use early `return` instead of nested `if` blocks.
- Use `pcall` only around calls that can really fail (optional modules, user input), and handle the error.

## Neovim

- Use the Lua API, not Vimscript strings: `vim.opt`, `vim.keymap.set`, `vim.api.nvim_create_autocmd`, `vim.api.nvim_create_user_command`.
- Give every keymap a `desc`, and every autocmd a group or a `desc`.
- Prefer built-in features (`vim.lsp`, `vim.diagnostic`, `vim.ui`, `vim.fs`) before adding a plugin.
- Configure plugins through their `opts`/`setup()` table. Only write a `config` function when setup needs more than a table.
- One plugin per file in `lua/plugins/`, named after the plugin.

## Avoid

- `vim.cmd` with multi-line Vimscript when a Lua API exists.
- Deprecated APIs (`vim.loop`, `vim.lsp.get_active_clients`, `vim.api.nvim_buf_set_option`). Check `:h deprecated`.
