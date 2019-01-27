#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
	bash ~/dotfiles/macos/updateOSX.sh
	bash ~/dotfiles/installScripts/pre-setup.sh
	bash ~/dotfiles/installScripts/makeSymlinks.sh 
	bash ~/dotfiles/installScripts/setupGit.sh
	bash ~/dotfiles/macos/installApplicationsWithBrew.sh
	bash ~/dotfiles/macos/setupMacOsDefaults.sh
	bash ~/dotfiles/macos/setupDock.sh
	source ~/.bash_profile;
	vim +PluginInstall +qall
  tmux source-file ~/.tmux.conf 
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
