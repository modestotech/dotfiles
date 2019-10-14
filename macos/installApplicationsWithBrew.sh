#!/bin/bash

# Install/update Homebrew
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
		echo "Brew is not installed, installing..."
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
		echo "Brew is already installed"
		read -p "Do you want to uninstall existing brew packages? (y/n) " -n 1;
		echo "";
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			# Remove all installed formulas
			if [[ $(brew list) ]]; then
					echo "Removing brew formulas"
					brew cleanup -s
					brew uninstall --force $(brew list) --ignore-dependencies
			fi
			if [[ $(brew cask list) ]]; then
					echo "Removing brew cask formulas"
					brew cask uninstall --force $(brew cask list)
			fi
		fi;
		echo "Updating brew"
    brew update
    brew upgrade
		echo "Updating brew cask"
		brew cask upgrade
fi

# Outdated GNU packages
brew install coreutils # Conatins the most essential UNIX stuff
brew install binutils
brew install diffutils
brew install ed 
brew install findutils 
brew install gawk
brew install gnu-indent 
brew install gnu-sed 
brew install gnu-tar 
brew install gnu-which 
brew install gnutls
brew install grep 
brew install gzip
brew install reattach-to-user-namespace # Needed for copy pasting from Tmux
brew install screen
brew install watch
brew install wdiff
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
brew install unzip
brew install vim
brew install zsh

echo "Outdated non-GNU brew packages are installed."
sleep 1

# Install utility packages
brew install awscli
brew install cloc
brew install dockutil
brew install htop
brew install httpie
brew install kubernetes-cli
brew install lynx
brew install mas
brew install markdown
brew install mongodb
brew install node
brew install pandoc
brew install tmux
brew install tree # Prints dir tree
brew install watchman

echo "Success! Brew utlity formulas are installed."
sleep 1

# Apps
brew cask install dropbox
brew cask install google-chrome
brew cask install google-backup-and-sync
brew cask install postman
brew cask install visual-studio-code
brew cask install virtualbox

# Frameworks etc
brew cask install java
brew cask install osxfuse # File system stuff
brew install git-credential-manager # Has to be installed after java
brew install sshfs # For access to remote older with ssh

echo "Success! MacOS applications are installed with brew cask."
sleep 1

# Utilities
brew cask install cheatsheet
brew cask install loading
brew cask install minikube
brew cask install shiftit

echo "Success! MacOS utilities are installed with brew cask."
sleep 1

# ...and then.
echo "Success! Brew applications are installed."
