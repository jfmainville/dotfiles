#!/bin/bash

# Install the base tools
brew install neovim tmux ripgrep git lazygit shellcheck stylua

# Install the Packer package manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Copy the custom LazyGit configuration over to the application folder
cp -f ~/.config/nvim/lazygit/config.yml ~/Library/Application\ Support/lazygit/

# Copy the custom tmux configuration file to the application folder
cp -f ~/.config/nvim/tmux/tmux.conf ~/.config/tmux/

# LSPs and Formatters packages
pip install black
sudo npm install -g typescript-language-server pyright @ansible/ansible-language-server dockerfile-language-server-nodejs prettier bash-language-server intelephense

# DAP base configuration
mkdir ~/.virtualenvs
cd ~/.virtualenvs || return
python -m venv debugpy
debugpy/bin/python -m pip install debugpy
