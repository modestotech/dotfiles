#!/bin/bash

softwareupdate --install --all
xcode-select --install # Xcode command line tools 
mas upgrade # Upgrades outdated apps from the app store
