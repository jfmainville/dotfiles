#!/bin/bash

# Set zsh as the default shell
sudo chsh -s /bin/zsh

# Fix the telescope-fzf-native.nvim plugin integration
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim && make && cd -
