# Neovim

This repository contains the code used to deploy my Neovim configuration.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine.

### Prerequisites

The following applications need to be installed on the local workstation to use and manage Neovim:

| Application       | Minimum Version | Link                                                            |
| :---------------- | :-------------: | :-------------------------------------------------------------- |
| neovim            |     0.9.5 +     | [Link](https://github.com/neovim/neovim/blob/master/INSTALL.md) |
| brew (MacOS only) |    4.3.21 +     | [Link](https://brew.sh/)                                        |

### Initialization

Once you installed all the required prerequisites, you can now proceed with the initialization of the providers and
backend by completing the following steps:

1. Create the following directory on your local workstation:

   `mdkir -p ~/.config/nvim`

2. Execute the below command to download the repository to your local machine:

   `git clone git@github.com:jfmainville/nvim.git ~/.config/nvim`

3. Navigate to the repository directory:

   `cd ~/.config/nvim`

4. To complete the install of all the necessary dependencies for Neovim, execute the following bash script as `root`:

   ```
   chmod + ~/.config/nvim/init.sh
   ~/.config/nvim/init.sh
   ```

## Folder Structure

The table below presents the folder structure for this repository:

| Folder      | Description                                            |
| ----------- | :----------------------------------------------------- |
| colors      | Contains the custom colorscheme files                  |
| kitty       | Contains the Kitty terminal configuration file         |
| lazygit     | Contains the LazyGit configuration file                |
| lua         | Contains the Neovim specific configurations            |
| lua/plugins | Contains the list of plugins deployed using Lazy.nvim  |
| tmux        | Contains the TMUX terminal emulator configuration file |

## Plugins

The following table shows the list of all the plugins that are used by Neovim with their purpose:

| Plugin Name                                                                  | Purpose          |
| ---------------------------------------------------------------------------- | :--------------- |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap)                         | Debugging        |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)                       | Debugging UI     |
| [nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python)           | Python Debugger  |
| [telescope](https://github.com/nvim-telescope/telescope.nvim)                | Navigator        |
| [bufferline](https://github.com/akinsho/bufferline.nvim)                     | Utility          |
| [vim-kitty-navigator](https://github.com/knubie/vim-kitty-navigator)         | Navigation       |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)        | Code Highlighter |
| [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim)   | Utility          |
| [undotree](https://github.com/mbbill/undotree)                               | Utility          |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)                  | Git              |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)          | Theme            |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)            | Utility          |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim)                     | Utility          |
| [flash.nvim](https://github.com/folke/flash.nvim)                            | Navigation       |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                 | Theme            |
| [vim-fugitive](https://github.com/tpope/vim-fugitive)                        | Git              |
| [oil.nvim](https://github.com/stevearc/oil.nvim)                             | File Explorer    |
| [conform.nvim](https://github.com/stevearc/conform.nvim)                     | Formatter        |
| [ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim)                     | ChatGPT          |
| [lsp-zero.nvim](https://github.com/VonHeikemen/lsp-zero.nvim)                | LSP              |
| [nvim-lspconfig.nvim](https://github.com/neovim/nvim-lspconfig)              | LSP              |
| [mason.nvim](https://github.com/williamboman/mason.nvim)                     | LSP              |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | LSP              |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                              | LSP              |
| [lspkind.nvim](https://github.com/onsails/lspkind.nvim)                      | Autocompletion   |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)                          | Autocompletion   |
| [cmp-path](https://github.com/hrsh7th/cmp-path)                              | Autocompletion   |
| [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)                   | Autocompletion   |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)                      | Autocompletion   |
| [cmp-nvim-lua](https://github.com/hrsh7th/cmp-nvim-lua)                      | Autocompletion   |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip)                               | Snippets         |
| [friendly-snippers](https://github.com/rafamadriz/friendly-snippets)         | Snippets         |
