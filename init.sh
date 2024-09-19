#!/bin/bash

# Install the base tools
brew install dpkg neovim fzf ripgrep git shfmt clang-format stylua zsh-autosuggestions zsh-syntax-highlighting eza python-packaging

# Configure zsh-autosuggestions
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc

# Configure zsh-syntax-highlighting
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>~/.zshrc

# Configure EZA
echo 'alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"' >>~/.zshrc

# LSPs and Formatters packages
pip3 install black ansible-lint
sudo npm install -g typescript-language-server pyright @ansible/ansible-language-server dockerfile-language-server-nodejs prettier bash-language-server intelephense @prisma/language-server vscode-langservers-extracted @tailwindcss/language-server cssmodules-language-server @olrtg/emmet-language-server

# DAP base configuration
mkdir ~/.virtualenvs
cd ~/.virtualenvs || return
python -m venv debugpy
debugpy/bin/python -m pip install debugpy
