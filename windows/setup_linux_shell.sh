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

# Create repos folder
print_msg "Creating ~/repos folder..."
mkdir -p "$HOME/repos"
echo "~/repos folder created."

# Set up SSH symlinks from Windows for Git with logical grouping
print_msg "Setting up SSH symlinks from Windows..."
WINDOWS_SSH_DIR="/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" | tr -d '\r')/.ssh"
LINUX_SSH_DIR="$HOME/.ssh"

mkdir -p "$LINUX_SSH_DIR"

if [ -f "$WINDOWS_SSH_DIR/id_ed25519" ] && [ -f "$WINDOWS_SSH_DIR/id_ed25519.pub" ]; then
    ln -sf "$WINDOWS_SSH_DIR/id_ed25519" "$LINUX_SSH_DIR/id_ed25519"
    ln -sf "$WINDOWS_SSH_DIR/id_ed25519.pub" "$LINUX_SSH_DIR/id_ed25519.pub"
    chmod 600 "$LINUX_SSH_DIR/id_ed25519"
    chmod 644 "$LINUX_SSH_DIR/id_ed25519.pub"
    echo "SSH keys symlinked from Windows."

    # SSH agent setup and GitHub connection test only if symlinks were successful
    print_msg "Starting ssh-agent and adding SSH key..."
    eval "$(ssh-agent -s)"
    if ssh-add "$LINUX_SSH_DIR/id_ed25519"; then
        print_msg "Testing SSH connection to GitHub..."
        if ssh -T git@github.com; then
            echo "SSH connection to GitHub successful."
        else
            echo "SSH connection to GitHub failed. Ensure the SSH key is added to your GitHub account."
        fi
    else
        echo "Failed to add SSH key. Check key existence and permissions."
    fi
else
    echo "Windows SSH keys not found. Please ensure SSH keys exist in $WINDOWS_SSH_DIR."
fi

print_msg "Setup complete! Restart your terminal for all changes to take effect."
