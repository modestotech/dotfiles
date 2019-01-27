#!/bin/bash

# Install/update Homebrew
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    brew upgrade
fi

# Updated GNU packages
brew install coreutils # Conatins the most essential UNIX stuff
brew install binutils
brew install diffutils
brew install ed --with-default-names
brew install findutils --with-default-names
brew install gawk
brew install gnu-indent --with-default-names
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-which --with-default-names
brew install gnutls
brew install grep --with-default-names
brew install gzip
brew install screen
brew install watch
brew install wdiff --with-gettext
brew install wget

# Outdated GNU command line tools
brew install bash
brew install bash-completion
brew install less

# Outdated packages (not GNU)
brew install file-formula
brew install git
brew install openssh
brew install perl
brew install python
brew install rsync
brew install svn
brew install unzip
brew install vim --override-system-vi
brew install zsh

# Install packages
brew install awscli
brew install cloc
brew install dockutil
brew install git-credential-eanager
brew install htop
brew install httpie
brew install kubernetes-cli
brew install lynx
brew install mas
brew install markdown
brew install mongodb
brew install node
brew install tmux
brew install tree # Prints dir tree 
brew install reattach-to-user-namespace # Needed for copy pasting from Tmux
brew install watchman
brew install z

# Wait a bit before moving on...
sleep 1

# ...and then.
echo "Success! Basic brew packages are installed."

# Apps
brew cask install dropbox
brew cask install google-chrome
brew cask install google-backup-and-sync
brew cask install postman
brew cask install visual-studio
brew cask install visual-studio-code
brew cask install virtualbox
brew cask install vlc
brew cask install slack

# Utilities
brew cask install cheatsheet
brew cask install fanny
brew cask install loading
brew cask install minikube # Needed for copying from tmux to pbcopy
brew cask install reattach-to-user-namespace # Needed for copying from tmux to pbcopy
brew cask install shiftit

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook qlvideo

# Wait a bit before moving on...
sleep 1

# ...and then.
echo "Success! Brew additional applications are installed."
