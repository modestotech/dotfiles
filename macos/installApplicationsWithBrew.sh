#!/bin/bash

# Install/update Homebrew
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
		echo "Brew is not installed, installing..."
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
		echo "Brew is already installed, removing current formulas..."
	  # Remove all installed formulas
	  brew uninstall --force $(brew list) --ignore-dependencies
	  brew cask uninstall --force $(brew cask list)
		brew cleanup -s
		brew cask cleanup
		# Upgrade brew
    brew update
    brew upgrade
fi

# Outdated GNU packages
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

echo "Outdated GNU brew packages are installed."
sleep 1

# Outdated GNU command line tools
brew install bash
brew install bash-completion
brew install less

echo "Outdated GNU command line tools brew packages are installed."
sleep 1

# Outdated packages (not GNU)
brew install file-formula
brew install git
brew install openssh
brew install perl
brew install python
brew install rsync
brew install svn
brew install unzip
brew install vim --with-override-system-vi
brew install zsh

echo "Outdated non-GNU brew packages are installed."
sleep 1

# Install utility packages
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

echo "Success! Brew utlity formulas are installed."
sleep 1

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

echo "Success! MacOS applications are installed with brew cask."
sleep 1

# Utilities
brew cask install cheatsheet
brew cask install fanny
brew cask install loading
brew cask install minikube
brew cask install shiftit

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook suspicious-package quicklookase qlvideo

echo "Success! MacOS utilities are installed with brew cask."
sleep 1

# ...and then.
echo "Success! Brew applications are installed."
