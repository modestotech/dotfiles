#!/bin/bash

############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bash_aliases bash_logout bash_profile bashrc bin gitconfig inputrc tmux.conf vimfunctions vimmappings vimplugins vimrc vimsnippets vim zshrc" 
# list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "Done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "Done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing $file from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -sfn $dir/$file ~/.$file
		# -fn flag is needed for the .vim dir, see example:
		# https://superuser.com/questions/81164/why-create-a-link-like-this-ln-nsf
done

echo "All symlinks created"

