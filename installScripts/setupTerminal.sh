#!/usr/bin/env bash

# Install zsh, includes changing shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Pull Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Pull Terminal Dracula theme
git clone https://github.com/dracula/terminal-app.git ~/dracula-theme

vim +PluginInstall +qall

echo "Choose the dracula theme in Terminal settings, located in (~/dracula-theme)"
