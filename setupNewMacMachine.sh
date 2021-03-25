#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
	bash ~/dotfiles/macos/updateOSX.sh
	bash ~/dotfiles/installScripts/pre-setup.sh
	bash ~/dotfiles/installScripts/makeSymlinks.sh 
	bash ~/dotfiles/macos/installApplicationsWithBrew.sh
	#bash ~/dotfiles/macos/setupMacOsDefaults.sh
	bash ~/dotfiles/macos/setupDock.sh
	bash ~/dotfiles/installScripts/setupTerminal.sh
	bash ~/dotfiles/installScripts/setupGit.sh
	tmux source-file ~/.tmux.conf 
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
