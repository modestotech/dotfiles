#!/usr/bin/env bash

brew upgrade # Upgrade brew packages
brew cleanup -s # Clean up previous installs 
brew cask cleanup # Clean up previous cask installs 

# Some diagnosis
brew doctor # Check system for potential problems
brew missing # Checks all installed formulas for missing dependencies

# IDE stuff
vim +PluginUpdate +qall
cd ~/dracula-theme/ && git pull && cd -

# MacOS
mas outdated # Print outdated apps from App Store
echo “Upgrade apps with mas upgrade”

# Dev
npm update -g # Updates global npm packages
