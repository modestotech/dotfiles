#!/bin/bash

softwareupdate --install --all

xcode-select -p >/dev/null
if [[ $? != 0 ]] ; then
	xcode-select --install
fi
