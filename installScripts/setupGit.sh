#!/bin/bash

file=~/.gitconfig.local
localgit="[user]\n\tname = John Doe\n\temail = john.doe@gmail.com\n\tusername = johndoe\n"

if [ ! -f "$file" ] ; then
    touch "$file"
		printf "$localgit" > $file
		echo "$file was created, add your name and email"
else
    echo ~/.gitconfig.local already exists, it should contain user Git user information
		printf "$localgit"
fi
