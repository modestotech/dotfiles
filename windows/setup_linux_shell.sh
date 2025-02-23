#!/bin/bash

set -e  # Exit on error

# Function to print messages
print_msg() {
    echo "==============================="
    echo "$1"
    echo "==============================="
}

setup_file_permissions() {
    # Check if the automount section with options = "metadata" exists
    if ! grep -q '^\[automount\]' /etc/wsl.conf || ! grep -q 'options = "metadata"' /etc/wsl.conf; then
        # Append the automount section with options = "metadata"
        # The "metadata" option ensures accurate handling of file metadata like permissions and timestamps
        echo -e "\n[automount]\noptions = \"metadata\"" | sudo tee -a /etc/wsl.conf > /dev/null
    fi
}

# Install zsh and Oh My Zsh with Powerlevel10k
install_zsh() {
    if ! command -v zsh &> /dev/null; then
        print_msg "Installing zsh and oh-my-zsh..."
        sudo apt update && sudo apt install -y zsh curl git
    else
        echo "zsh already installed."
    fi

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_msg "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "Oh My Zsh already installed."
    fi

    if [ "$SHELL" != "$(command -v zsh)" ]; then
        chsh -s "$(command -v zsh)"
        export SHELL="$(command -v zsh)"
        echo "zsh set as the default shell."
    fi

    install_powerlevel10k
}

# Install Powerlevel10k theme
install_powerlevel10k() {
    local theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [ ! -d "$theme_dir" ]; then
        print_msg "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir"
        sed -i 's|^ZSH_THEME=.*|ZSH_THEME=\"powerlevel10k/powerlevel10k\"|' "$HOME/.zshrc" || echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
        echo '[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh' >> "$HOME/.zshrc"

    # Source .p10k.zsh in .zshrc if not already included
    if ! grep -q '\\.p10k\\.zsh' "$HOME/.zshrc"; then
        echo '[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh' >> "$HOME/.zshrc"
    fi
    else
        echo "Powerlevel10k theme already installed."
    fi
}

# SSH key handling for WSL
setup_ssh() {
    local win_ssh_dir=$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")/.ssh
    local linux_ssh_dir="$HOME/.ssh"

    mkdir -p "$linux_ssh_dir"
    chmod 600 "$linux_ssh_dir"

    if [ -f "$win_ssh_dir/id_ed25519" ]; then
        sudo cp "$win_ssh_dir/id_ed25519" "$linux_ssh_dir/id_ed25519"
        sudo cp "$win_ssh_dir/id_ed25519.pub" "$linux_ssh_dir/id_ed25519.pub"
        
        sudo chown -R $USER:$USER $linux_ssh_dir
        sudo chmod 600 "$linux_ssh_dir/id_ed25519"
        sudo chmod 644 "$linux_ssh_dir/id_ed25519.pub"

        eval `ssh-agent -s`
        ssh-add $linux_ssh_dir/id_ed25519
        echo "SSH keys linked and added to agent."
    else
        echo "Windows SSH keys not found."
    fi
}

# Install Azure CLI
install_azure_cli() {
    if [ ! -f "/usr/bin/az" ] && [ ! -f "/usr/local/bin/az" ]; then
        print_msg "Installing Azure CLI..."
        curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    else
        echo "Azure CLI already installed."
    fi
}

# Install kubectl
install_kubectl() {
    if [ ! -f "/usr/bin/kubectl" ] && [ ! -f "/usr/local/bin/kubectl" ]; then
        print_msg "Installing kubectl..."
        sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
        curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | \
            sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
        echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' |
            sudo tee /etc/apt/sources.list.d/kubernetes.list
        sudo apt-get update && sudo apt-get install -y kubectl
    else
        echo "kubectl already installed."
    fi
}

# Install .NET SDK
install_dotnet() {
    if ! command -v dotnet &> /dev/null; then
        print_msg "Installing .NET SDK 8.0..."
        wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb
        sudo apt update && sudo apt install -y dotnet-sdk-8.0
    else
        echo ".NET SDK already installed."
    fi
}

# Install NVM and Node.js
install_nvm_node() {
    if [ ! -d "$HOME/.nvm" ]; then
        print_msg "Installing NVM and Node.js..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.zshrc"
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \\. "$NVM_DIR/nvm.sh"' >> "$HOME/.zshrc"
    fi
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install node && nvm use node
    echo "NVM and Node.js set up."
}

# Docker check
check_docker() {
    if timeout 5 docker version &> /dev/null; then
        echo "Docker is accessible from WSL."
    else
        echo "Docker not accessible. Ensure Docker Desktop with WSL integration is enabled."
    fi
}

# Git configuration
configure_git() {
    local name="Max"
    git config --global user.name "$name"
    echo "Git configured with name: $name"
}

# Create essential aliases
create_aliases() {
    grep -qxF 'alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"' "$HOME/.zshrc" || \
        echo 'alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"' >> "$HOME/.zshrc"
    grep -qxF 'alias azlogin="az login --use-device-code"' "$HOME/.zshrc" || \
        echo 'alias azlogin="az login --use-device-code"' >> "$HOME/.zshrc"
    echo "Aliases added."
}

# Main execution flow
main() {
    print_msg "Starting WSL Development Environment Setup..."
    mkdir -p "$HOME/repos"
    setup_file_permissions
    install_zsh
    setup_ssh
    install_azure_cli
    install_kubectl
    install_dotnet
    install_nvm_node
    check_docker
    configure_git
    create_aliases
    print_msg "Setup complete! All changes applied."
}

main
