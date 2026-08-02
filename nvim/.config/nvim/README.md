# Neovim Configuration

This is the Neovim configuration deployed by the [dotfiles](https://github.com/jfmainville/dotfiles) repository. It is
managed with [lazy.nvim](https://github.com/folke/lazy.nvim); see the main repository README for the plugin list and
installation instructions.

## Load Order

| File               | Purpose                                                              |
| ------------------ | :-------------------------------------------------------------------- |
| `init.lua`         | Entry point, requires `lua/init.lua`                                  |
| `lua/init.lua`     | Requires the modules below, in order                                  |
| `lua/set.lua`      | Core `vim.opt`/`vim.g` settings                                       |
| `lua/keymap.lua`   | Global, plugin-independent keymaps                                    |
| `lua/autocmd.lua`  | Global autocommands and user commands                                 |
| `lua/config/lazy.lua` | Bootstraps lazy.nvim and imports `lua/plugins/*`                   |

## Folder Structure

| Path             | Description                                                             |
| ---------------- | :------------------------------------------------------------------------ |
| `lua/plugins/`   | One file per plugin, returned as a lazy.nvim plugin spec                  |
| `lua/set.lua`    | Editor options                                                            |
| `lua/keymap.lua` | Keymaps that don't belong to a specific plugin                            |
| `lua/autocmd.lua`| Autocommands and user commands that don't belong to a specific plugin     |
| `typos.toml`     | Config for `typos_lsp`, consumed from `lua/plugins/mason.lua`             |
| `lazy-lock.json` | lazy.nvim lockfile, committed to pin plugin versions                      |

## LSP Servers

LSP servers are declared and enabled in `lua/plugins/mason.lua`, which also installs them via `mason.nvim`/
`mason-lspconfig.nvim`. Add a new server by adding it to both the `vim.lsp.enable(...)` calls and the
`ensure_installed` list in that file.

## Adding a Plugin

Add a new file under `lua/plugins/` returning a lazy.nvim plugin spec (see existing files for examples); it will be
picked up automatically via the `{ import = "plugins" }` spec in `lua/config/lazy.lua`. Remember to add it to the
plugin table in the main repository README.
