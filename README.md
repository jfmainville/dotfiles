# Dotfiles

This repository contains the code used to deploy my dotfiles configuration.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine.

### Prerequisites

The following applications need to be installed on the local workstation to use and manage Neovim:

| Application        | Minimum Version | Link                                                            |
| :----------------- | :-------------: | :-------------------------------------------------------------- |
| neovim             |     0.11 +      | [Link](https://github.com/neovim/neovim/blob/master/INSTALL.md) |
| nvm                |     0.39 +      | [Link](https://github.com/nvm-sh/nvm)                           |
| brew (MacOS only)  |    4.3.21 +     | [Link](https://brew.sh/)                                        |
| WSL (Windows only) |    2.3.26 +     | [Link](https://github.com/microsoft/WSL)                        |

> Neovim `0.11` or later is required: the LSP setup in `nvim/.config/nvim/lua/plugins/mason.lua` uses the
> `vim.lsp.config()` / `vim.lsp.enable()` API, and `nvim-treesitter` is pinned to its `main` branch. `nvm` is required
> because `init.sh` uses it to install Node and the `tree-sitter-cli` package.

### Initialization

#### MacOS / Linux

Once you installed all the required prerequisites, you can now proceed with the initialization of the providers and
backend by completing the following steps:

1. Install the prerequisites using the below command:

```bash
# MacOS
brew install neovim tmux stow ripgrep fzf zsh zsh-autosuggestions zsh-syntax-highlighting jandedobbeleer/oh-my-posh/oh-my-posh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# Debian/Ubuntu
sudo apt-get install neovim tmux stow ripgrep fzf
```

2. Execute the below command to download the repository to your local machine:

`git clone https://github.com/jfmainville/dotfiles.git`

3. Navigate to the dotfiles repository directory:

`cd ~/dotfiles`

4. To complete the install of all the necessary dependencies for Neovim, symlink the configuration files and execute
   the following bash script as your regular user (it calls `sudo` where needed):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
stow nvim tmux alacritty herdr
chmod +x ~/dotfiles/init.sh
~/dotfiles/init.sh

```

5. Open the Neovim application and load all the plugins using the `Lazy` command

6. If the Telescope FZF extension fails to load, build it manually (`init.sh` already runs this step):

```bash
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim && make && cd -

```

## Folder Structure

The table below presents the folder structure for this repository:

| Folder     | Description                                        |
| ---------- | :------------------------------------------------- |
| fonts      | Contains the fonts that needs to be deployed       |
| nvim       | Contains the Neovim configuration files            |
| oh-my-posh | Contains the Oh My Posh configuration files        |
| tmux       | Contains the Tmux configuration files              |
| alacritty  | Contains the alacritty terminal configuration file |
| herdr      | Contains the Herdr terminal multiplexer config     |

Every folder except `fonts` and `oh-my-posh` is a [GNU Stow](https://www.gnu.org/software/stow/) package: its contents
mirror the target tree under `$HOME`, so `stow nvim` symlinks `nvim/.config/nvim` to `~/.config/nvim`.

## Oh My Posh

The `oh-my-posh` folder contains the configuration files for the Oh My Posh terminal theme configuration. To make it more flexible, it's possible to point the configuration to a remote file hosted in GitHub. Add the following line to the `~/.bashrc` or `~/.zshrc` file:

```bash
# Oh My Posh
eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/jfmainville/dotfiles/refs/heads/main/oh-my-posh/purist.omp.json)"
```

## Git

To make sure that the git configuration is properly setup, execute the following `git` commands:

```bash
git config --global user.name "Jean-Frederic Mainville"
git config --global user.email "jfmainville@outlook.com"
git config --global --type bool push.autoSetupRemote true
```

## Neovim

The Neovim configuration is managed with [lazy.nvim](https://github.com/folke/lazy.nvim) and lives in
`nvim/.config/nvim`. See [its README](nvim/.config/nvim/README.md) for the module load order, the folder layout, where
the LSP servers are declared, and how to add a new plugin.

## Plugins

The following table shows the list of all the plugins that are used by Neovim with their purpose:

| Plugin Name                                                                      | Purpose          |
| -------------------------------------------------------------------------------- | :--------------- |
| [autotag](https://github.com/windwp/nvim-ts-autotag)                             | Utility          |
| [aerial](https://github.com/stevearc/aerial.nvim)                                | LSP              |
| [telescope](https://github.com/nvim-telescope/telescope.nvim)                    | Navigator        |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)            | Code Highlighter |
| [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim)       | Utility          |
| [codediff](https://github.com/esmuellert/codediff.nvim)                          | Utility          |
| [undotree](https://github.com/mbbill/undotree)                                   | Utility          |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)                      | Git              |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)              | Theme            |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)                | Utility          |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim)                         | Utility          |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                     | Theme            |
| [vim-fugitive](https://github.com/tpope/vim-fugitive)                            | Git              |
| [conform.nvim](https://github.com/stevearc/conform.nvim)                         | Formatter        |
| [render-markdown](https://github.com/MeanderingProgrammer/render-markdown.nvim)  | Utility          |
| [noice](https://github.com/folke/noice.nvim)                                     | Utility          |
| [treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Utility          |
| [trouble.nvim](https://github.com/folke/trouble.nvim)                            | Utility          |
| [nvim-lspconfig.nvim](https://github.com/neovim/nvim-lspconfig)                  | LSP              |
| [mason.nvim](https://github.com/williamboman/mason.nvim)                         | LSP              |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)     | LSP              |
| [blink.cmp](https://github.com/saghen/blink.cmp)                                 | LSP              |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip)                                   | Snippets         |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)             | Snippets         |
| [oil.nvim](https://github.com/stevearc/oil.nvim)                                 | Navigator        |
| [atlas.nvim](https://github.com/emrearmagan/atlas.nvim)                          | Git              |
| [fluovibe.nvim](https://github.com/jfmainville/fluovibe.nvim)                    | Theme            |
| [nudge.nvim](https://github.com/jfmainville/nudge.nvim)                          | Utility          |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)                         | Utility          |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim)                              | Utility          |
| [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Navigator     |
| [vim-rhubarb](https://github.com/tpope/vim-rhubarb)                              | Git              |
| [fugitive-azure-devops](https://github.com/cedarbaum/fugitive-azure-devops.vim)  | Git              |
