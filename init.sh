#!/bin/bash

# Install the base tools
case "$(uname -s)" in
Linux)
  OS="Linux"
  sudo apt-get update && sudo apt-get install -y \
    neovim \
    fzf \
    ripgrep \
    git \
    shfmt \
    clang-format \
    stylua \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    eza \
    gcc \
    python-packaging
  ;;
Darwin)
  OS="MacOS"
  brew install \
    dpkg \
    neovim \
    fzf \
    ripgrep \
    git \
    shfmt \
    clang-format \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    eza \
    python-packaging
  PATH_PREFIX=$(brew --prefix)
  ;;
CYGWIN* | MINGW32* | MSYS* | MINGW*)
  OS="Windows"
  ;;
*)
  OS="Unknown"
  ;;
esac

# Check the existence of the ~/.zshrc configuration file
if [ -f ~/.zshrc ]; then
  # Configure zsh-autosuggestions
  echo "source $PATH_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc

  # Configure zsh-syntax-highlighting
  echo "source $PATH_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>~/.zshrc

  # Configure EZA
  echo 'alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"' >>~/.zshrc
else
  echo "~/.zshrc file does not exist."
fi

# LSPs and Formatters packages
if command -v python3 &>/dev/null; then
  pip3 install black ansible-lint
else
  echo "Python3 is not installed."
fi

if command -v npm &>/dev/null; then
  sudo npm install -g \
    typescript-language-server \
    pyright \
    @ansible/ansible-language-server \
    dockerfile-language-server-nodejs \
    prettier \
    bash-language-server \
    intelephense \
    @prisma/language-server \
    vscode-langservers-extracted \
    @tailwindcss/language-server \
    cssmodules-language-server \
    @olrtg/emmet-language-server \
    @johnnymorganz/stylua-bin
else
  echo "NPM is not installed."
fi

# Base git commands
git config --global push.autoSetupRemote true
git config --global user.email jfmainville@outlook.com
git config --global user.name Jean-Frederic Mainville
