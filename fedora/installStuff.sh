#!/bin/sh

# Update dnf
sudo dnf upgrade
echo "Upgraded dnf"
sleep 1

# Utilities
sudo dnf install git -y
sudo dnf install htop -y
sudo dnf install vim-enhanced vim-X11 -y
sudo dnf install tmux -y
sudo dnf install httpie -y # For http requests

echo "Success! Utilities have been installed."
sleep 1

# Dev stuff
sudo dnf install node -y

echo "Success! Dev stuff has been installed."
sleep 1

# Apps
sudo dnf install chromium

echo "Success! Apps have been installed."
sleep 1

# ...and then.
echo "Success! A lot of stuff has been installed."
