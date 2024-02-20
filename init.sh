# !/bin/bash

# Install the base tools
brew install neovim tmux ripgrep git

# Install the Packer package manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
