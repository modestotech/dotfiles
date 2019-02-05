#!/usr/bin/env bash

# Pull Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Pull Terminal Dracula theme
git clone https://github.com/dracula/terminal-app.git ~/dracula-theme

vim +PluginInstall +qall

echo "Choose the dracula theme in Terminal settings, located in (~/dracula-theme)"
