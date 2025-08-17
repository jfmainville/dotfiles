# Dotfiles

This repository contains the code used to deploy my dotfiles configuration.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine.

### Prerequisites

The following applications need to be installed on the local workstation to use and manage Neovim:

| Application        | Minimum Version | Link                                                            |
| :----------------- | :-------------: | :-------------------------------------------------------------- |
| neovim             |     0.9.5 +     | [Link](https://github.com/neovim/neovim/blob/master/INSTALL.md) |
| brew (MacOS only)  |    4.3.21 +     | [Link](https://brew.sh/)                                        |
| WSL (Windows only) |    2.3.26 +     | [Link](https://github.com/microsoft/WSL)                        |

### Initialization

#### MacOS / Linux

Once you installed all the required prerequisites, you can now proceed with the initialization of the providers and
backend by completing the following steps:

1. Install the `stow` application using the below command:

```bash
# MacOS
brew install neovim tmux stow

# Debian/Ubuntu
sudo apt-get install neovim tmux stow
```

2. Execute the below command to download the repository to your local machine:

`git clone git@github.com:jfmainville/dotfiles.git ~`

3. Navigate to the dotfiles repository directory:

`cd ~/dotfiles`

4. To complete the install of all the necessary dependencies for Neovim, execute the following bash script as `root`:

```bash
stow nvim tmux wezterm
chmod + ~/.config/nvim/init.sh
~/.config/nvim/init.sh

```

5. Execute the following command to complete the installation of the Telescope FZF extension plugin:

```bash
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim && make && cd -

```

6. Open the Neovim application and load all the plugins using the `Lazy` command

## Folder Structure

The table below presents the folder structure for this repository:

| Folder     | Description                                      |
| ---------- | :----------------------------------------------- |
| fonts      | Contains the fonts that needs to be deployed     |
| nvim       | Contains the Neovim configuration files          |
| oh-my-posh | Contains the Oh My Posh configuration files      |
| tmux       | Contains the Tmux configuration files            |
| wezterm    | Contains the Wezterm terminal configuration file |

## Oh My Posh

The `oh-my-posh` folder contains the configuration files for the Oh My Posh terminal theme configuration. To make it more flexible, it's possible to point the configuration to a remote file hosted in GitHub. Add the following line to the `~/.bashrc` or `~/.zshrc` file:

```bash
# Oh My Posh
eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/jfmainville/nvim/refs/heads/main/oh-my-posh/purist.omp.json)"
```

## Plugins

The following table shows the list of all the plugins that are used by Neovim with their purpose:

| Plugin Name                                                                  | Purpose          |
| ---------------------------------------------------------------------------- | :--------------- |
| [autotag](https://github.com/windwp/nvim-ts-autotag)                         | Utility          |
| [aerial](https://github.com/stevearc/aerial.nvim)                            | Utility          |
| [telescope](https://github.com/nvim-telescope/telescope.nvim)                | Navigator        |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)        | Code Highlighter |
| [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim)   | Utility          |
| [diffview](https://github.com/sindrets/diffview.nvim)                        | Utility          |
| [undotree](https://github.com/mbbill/undotree)                               | Utility          |
| [kulala](https://github.com/mistweaverco/kulala.nvim)                        | Utility          |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)                  | Git              |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)          | Theme            |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)            | Utility          |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim)                     | Utility          |
| [flash.nvim](https://github.com/folke/flash.nvim)                            | Navigation       |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                 | Theme            |
| [vim-fugitive](https://github.com/tpope/vim-fugitive)                        | Git              |
| [conform.nvim](https://github.com/stevearc/conform.nvim)                     | Formatter        |
| [markview](https://github.com/OXY2DEV/markview.nvim)                         | Utility          |
| [harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)             | Navigation       |
| [octo.nvim](https://github.com/pwntester/octo.nvim)                          | Utility          |
| [noice](https://github.com/folke/noice.nvim)                                 | Utility          |
| [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)                   | Utility          |
| [nvim-notify](https://github.com/rcarriga/nvim-notify)                       | Utility          |
| [trouble.nvim](https://github.com/folke/trouble.nvim)                        | Utility          |
| [code-companion](https://github.com/olimorris/codecompanion.nvim)            | ChatGPT          |
| [nvim-lspconfig.nvim](https://github.com/neovim/nvim-lspconfig)              | LSP              |
| [mason.nvim](https://github.com/williamboman/mason.nvim)                     | LSP              |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | LSP              |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                              | LSP              |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)                          | Autocompletion   |
| [cmp-path](https://github.com/hrsh7th/cmp-path)                              | Autocompletion   |
| [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)                   | Autocompletion   |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)                      | Autocompletion   |
| [cmp-nvim-lua](https://github.com/hrsh7th/cmp-nvim-lua)                      | Autocompletion   |
| [copilot.lua](https://github.com/zbirenbaum/copilot.lua)                     | Autocompletion   |
| [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp)                     | Autocompletion   |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip)                               | Snippets         |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)         | Snippets         |
