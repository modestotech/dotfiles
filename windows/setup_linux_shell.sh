#!/bin/bash

set -e

# Function to print messages
print_msg() {
    echo "==============================="
    echo "$1"
    echo "==============================="
}

# Install zsh and oh-my-zsh
print_msg "Installing zsh and oh-my-zsh..."
sudo apt update && sudo apt install -y zsh curl git

# Install oh-my-zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
else
    echo "oh-my-zsh already installed."
fi

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    echo "zsh set as the default shell."
fi

# Install Powerlevel10k theme
print_msg "Installing Powerlevel10k theme..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Set Powerlevel10k in .zshrc
if grep -q '^ZSH_THEME=' "$HOME/.zshrc"; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
else
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
fi

echo "Powerlevel10k set as the zsh theme."

# Enable clipboard access
print_msg "Enabling clipboard access..."
sudo apt install -y clip
if ! grep -q 'alias copy=' "$HOME/.zshrc"; then
    echo "alias copy=\"clip.exe\"" >> "$HOME/.zshrc"
    echo "Clipboard alias added: Use 'copy' to copy to Windows clipboard."
fi

# Set up VSCode integration
print_msg "Setting up VSCode integration..."
if ! command -v code &> /dev/null; then
    echo "VSCode is not installed. Please install VSCode and the Remote - WSL extension from https://code.visualstudio.com/"
else
    echo "VSCode is already installed. You can use 'code .' to open the current folder in VSCode."
fi

# Add update command alias
print_msg "Adding update command alias..."
if ! grep -q 'alias update=' "$HOME/.zshrc"; then
    echo "alias update=\"sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y\"" >> "$HOME/.zshrc"
    echo "Alias 'update' added: Use 'update' to update and upgrade the system."
fi

# Create repos folder and set up SSH if it doesn't exist
print_msg "Creating ~/repos folder and setting up SSH keys..."
mkdir -p "$HOME/repos"
echo "~/repos folder created."

if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
    print_msg "Generating SSH key (Ed25519)..."
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$HOME/.ssh/id_ed25519" -N ""
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_ed25519"
    echo "SSH key generated. Public key is:"
    cat "$HOME/.ssh/id_ed25519.pub"
else
    echo "ed25519 SSH key already exists."
fi

print_msg "Setup complete! Restart your terminal for all changes to take effect."
