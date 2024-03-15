#!/bin/bash

# Install the base tools
brew install neovim tmux ripgrep git lazygit shellcheck stylua

# Install the Packer package manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

cp ./lazygit/config.yaml ~/Library/Application\ Support/lazygit/

pip install black

npm install -g typescript-language-server pyright @ansible/ansible-language-server dockerfile-language-server-nodejs prettier bash-language-server

# DAP
mkdir ~/.virtualenvs
cd ~/.virtualenvs
python -m venv debugpy
debugpy/bin/python -m pip install debugpy
