# !/bin/bash

# Install the base tools
brew install neovim tmux ripgrep git lazygit

# Install the Packer package manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install NVIM DAP
git clone https://github.com/mfussenegger/nvim-dap.git ~/.config/nvim/pack/plugins/start/nvim-dap

cp ./lazygit/config.yaml ~/Library/Application\ Support/lazygit/
