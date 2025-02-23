#!/bin/bash

set -e

# Function to print messages
print_msg() {
    echo "==============================="
    echo "$1"
    echo "==============================="
}

# Install zsh and oh-my-zsh if not already installed
if ! command -v zsh &> /dev/null; then
    print_msg "Installing zsh and oh-my-zsh..."
    sudo apt update && sudo apt install -y zsh curl git

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
    else
        echo "oh-my-zsh already installed."
    fi

    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s $(which zsh)
        echo "zsh set as the default shell."
        export SHELL=$(which zsh)
    fi
else
    echo "zsh already installed."
fi

# Install Oh My Zsh and Powerlevel10k theme if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
        echo "Failed to install Oh My Zsh." && exit 1
    }
fi

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    # Set theme in .zshrc
    if grep -q '^ZSH_THEME=' "$HOME/.zshrc"; then
        sed -i 's|^ZSH_THEME=.*|ZSH_THEME=\"powerlevel10k/powerlevel10k\"|' "$HOME/.zshrc"
    else
        echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
    fi
else
    echo "Powerlevel10k theme already installed."
fi

# VSCode integration check
if ! command -v code &> /dev/null; then
    print_msg "VSCode not found. Please install VSCode and the Remote - WSL extension."
else
    echo "VSCode is already installed."
fi

# Alias for system updates
if ! grep -q 'alias update=' "$HOME/.zshrc"; then
    echo "alias update=\"sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y\"" >> "$HOME/.zshrc"
    echo "Alias 'update' added."
fi

# Create repos directory if it doesn't exist
if [ ! -d "$HOME/repos" ]; then
    mkdir -p "$HOME/repos"
    echo "~/repos folder created."
else
    echo "~/repos folder already exists."
fi

# SSH setup with symlink from Windows (only if not already set up)

# Get the Windows user profile path using cmd.exe (redirecting any errors related to UNC paths)
WINDOWS_USER_HOME_PATH=$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")

WINDOWS_SSH_DIR="$WINDOWS_USER_HOME_PATH/.ssh"
LINUX_SSH_DIR="$HOME/.ssh"
mkdir -p "$LINUX_SSH_DIR"

# Check for Windows SSH keys
if [ -f "$WINDOWS_SSH_DIR/id_ed25519" ] && [ -f "$WINDOWS_SSH_DIR/id_ed25519.pub" ]; then
    # Create symlinks if they don't exist
    if [ ! -L "$LINUX_SSH_DIR/id_ed25519" ] || [ ! -L "$LINUX_SSH_DIR/id_ed25519.pub" ]; then
        ln -sf "$WINDOWS_SSH_DIR/id_ed25519" "$LINUX_SSH_DIR/id_ed25519"
        ln -sf "$WINDOWS_SSH_DIR/id_ed25519.pub" "$LINUX_SSH_DIR/id_ed25519.pub"
        chmod 600 "$LINUX_SSH_DIR/id_ed25519"
        chmod 644 "$LINUX_SSH_DIR/id_ed25519.pub"
        echo "SSH keys symlinked from Windows."
    else
        echo "SSH keys are already symlinked."
    fi

    # Set permissions on SSH dirs
    chmod 700 $LINUX_SSH_DIR
    chmod 600 "$LINUX_SSH_DIR/id_ed25519"

    # Start SSH agent and add key
    eval "$(ssh-agent -s)"
    if ssh-add "$LINUX_SSH_DIR/id_ed25519"; then
        # Test SSH connection to GitHub
        if ssh -T git@github.com 2>&1 | grep -q "Hi"; then
            echo "SSH connection to GitHub successful."
        else
            echo "SSH connection to GitHub failed."
        fi
    else
        echo "Failed to add SSH key."
    fi
else
    echo "Windows SSH keys not found."
fi

# Check and install essential CLI tools
print_msg "Checking and installing CLI tools..."

# Ensure Azure CLI is installed in WSL regardless of Windows PATH
if [ ! -f "/usr/bin/az" ] && [ ! -f "/usr/local/bin/az" ]; then
    print_msg "Installing Azure CLI in WSL..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
else
    echo "Azure CLI already installed in WSL."
fi

# Ensure kubectl is installed in WSL regardless of Windows PATH
if [ ! -f "/usr/bin/kubectl" ] && [ ! -f "/usr/local/bin/kubectl" ]; then
    print_msg "Installing kubectl in WSL..."

    sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

    # This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

    sudo apt-get update
    sudo apt-get install -y kubectl
else
    echo "kubectl already installed in WSL."
fi

if ! command -v dotnet &> /dev/null; then
    wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt update && sudo apt install -y dotnet-sdk-8.0
else
    echo ".NET SDK already installed."
fi

# Improved NVM check: ensure proper detection before reinstall
if [ ! -d "$HOME/.nvm" ] || [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    print_msg "Installing NVM and latest Node.js..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

if ! nvm ls node &> /dev/null; then
    nvm install node
    nvm use node
    echo "NVM and latest Node.js installed."
else
    echo "NVM and latest Node.js already installed."
fi

# Docker check (expected to be in Windows)
if [ -S "/var/run/docker.sock" ] || docker version &> /dev/null; then
    echo "Docker is accessible from WSL."
else
    echo "Docker not found in WSL. Ensure Docker Desktop with WSL integration is enabled in Windows."
fi

# Setup Git credentials if not already done
if ! git config --global user.name &>/dev/null || ! git config --global user.email &>/dev/null; then
    GITHUB_NAME="Max"
    GITHUB_EMAIL="modestotechnology@gmail.com"

    # Set Git user info for GitHub
    git config --global user.name "$GITHUB_NAME"
    git config --global user.email "$GITHUB_EMAIL"
    echo "GitHub username and email set."
else
    echo "GitHub username and email are already set."
fi

# Azure login alias
if ! grep -q 'alias azlogin=' "$HOME/.zshrc"; then
    echo "alias azlogin=\"az login --use-device-code\"" >> "$HOME/.zshrc"
    echo "Alias 'azlogin' added."
fi

print_msg "Setup complete! All changes applied."

