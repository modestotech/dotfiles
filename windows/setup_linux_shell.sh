#!/bin/bash

# The script needs to be run a couple of times for all to take effect.

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
    else
        echo "Powerlevel10k theme already installed."
    fi
}

# SSH key handling for WSL
setup_ssh() {
    local win_ssh_dir=$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")/.ssh
    local linux_ssh_dir="$HOME/.ssh"

    mkdir -p "$linux_ssh_dir"
    chmod 700 "$linux_ssh_dir"

    local win_ed25519_private="$win_ssh_dir/id_ed25519"
    local win_ed25519_public="$win_ssh_dir/id_ed25519.pub"
    local linux_ed25519_private="$linux_ssh_dir/id_ed25519"
    local linux_ed25519_public="$linux_ssh_dir/id_ed25519.pub"

    if [[ -f $win_ed25519_private && -f $linux_ed25519_private ]]; then
        echo "ed25519 SSH keys already set up."
    elif [[ -f $win_ed25519_private && ! -f $linux_ed25519_private ]]; then
        sudo cp $win_ed25519_private $linux_ed25519_private
        sudo cp $win_ed25519_public $linux_ed25519_public
        
        sudo chown -R $USER:$USER $linux_ssh_dir
        sudo chmod 600 $linux_ed25519_private
        sudo chmod 644 $linux_ed25519_public

        eval `ssh-agent -s`
        ssh-add $linux_ed25519_private
        echo "ed25519 SSH keys linked and added to agent."
    else
        echo "Windows ed25519 SSH keys not found."
    fi

    local win_rsa_private="$win_ssh_dir/id_rsa"
    local win_rsa_public="$win_ssh_dir/id_rsa.pub"
    local linux_rsa_private="$linux_ssh_dir/id_rsa"
    local linux_rsa_public="$linux_ssh_dir/id_rsa.pub"

    if [[ -f $win_rsa_private && -f $linux_rsa_private ]]; then
        echo "rsa SSH keys already set up."
    elif [[ -f $win_rsa_private && ! -f $linux_rsa_private ]]; then
        sudo cp $win_rsa_private $linux_rsa_private
        sudo cp $win_rsa_public $linux_rsa_public
        
        sudo chown -R $USER:$USER $linux_ssh_dir
        sudo chmod 600 $linux_rsa_private
        sudo chmod 644 $linux_rsa_public

        eval `ssh-agent -s`
        ssh-add $linux_rsa_private
        echo "rsa SSH keys linked and added to agent."
    else
        echo "Windows rsa SSH keys not found."
    fi
}

install_powershell() {
    if [ ! -f "/usr/bin/pwsh" ] && [ ! -f "/bin/pwsh" ]; then
        print_msg "Installing Powershell..."

        # Update the list of packages
        sudo apt-get update

        # Install pre-requisite packages.
        sudo apt-get install -y wget apt-transport-https software-properties-common

        # Get the version of Ubuntu
        source /etc/os-release

        # Download the Microsoft repository keys
        wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb

        # Register the Microsoft repository keys
        sudo dpkg -i packages-microsoft-prod.deb

        # Delete the Microsoft repository keys file
        rm packages-microsoft-prod.deb

        # Update the list of packages after we added packages.microsoft.com
        sudo apt-get update

        ###################################
        # Install PowerShell
        sudo apt-get install -y powershell
    else
        echo "Powershell already installed."
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
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

        nvm install node && nvm use node
        echo "NVM and Node.js set up."
    else
        echo "nvm/node already installed."
    fi
}

install_jq() {
    if ! command -v jq &> /dev/null; then
        echo "Installing jq..."
        sudo apt-get update && sudo apt-get install jq -y
    else
        echo "jq already installed."
    fi
}

# Docker check
check_docker() {
    if timeout 5 docker --version &> /dev/null; then
        echo "Docker is accessible from WSL."
    else
        echo "Docker not accessible. Ensure Docker Desktop with WSL integration is enabled."
    fi
}

# Git configuration
configure_git() {
    local name="Max"
    git config --global user.name "$name"
    git config --global core.editor "vim"
    # For branch commands be cat per default, not less
    git config --global pager.branch false

    echo "Git configured with name: $name and setup vim as editor"
}

# Create essential aliases
create_aliases() {
    grep -qxF 'alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"' "$HOME/.zshrc" || \
        echo 'alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"' >> "$HOME/.zshrc"
    grep -qxF 'alias azlogin="az login --use-device-code"' "$HOME/.zshrc" || \
        echo 'alias azlogin="az login --use-device-code"' >> "$HOME/.zshrc"
    echo "Aliases added."
}

create_git_aliases() {
    # Add aliases
    git config --global alias.aa "add ."
    git config --global alias.ca "commit --amend"
    git config --global alias.can "commit --amend --no-edit"
    git config --global alias.co "checkout"
    git config --global alias.codev "checkout dev"
    git config --global alias.comain "checkout main"
    git config --global alias.comaster "checkout master"
    git config --global alias.bad "branch -a --merged"
    git config --global alias.bd "branch -d"
    git config --global alias.bD "branch -D"
    git config --global alias.fodev "fetch origin dev:dev"
    git config --global alias.fomain "fetch origin main:main"
    git config --global alias.fomaster "fetch origin master:master"
    git config --global alias.p "pull"
    git config --global alias.pf "push --force-with-lease"
    git config --global alias.rpo "remote prune origin"
    git config --global alias.rea "rebase --continue"
    git config --global alias.rec "rebase --continue"
    git config --global alias.red "rebase dev"
    git config --global alias.rid "rebase -i dev"
    git config --global alias.s "status"
    
    echo "Git aliases added."
}

# Main execution flow
main() {
    print_msg "Starting WSL Development Environment Setup..."
    mkdir -p "$HOME/repos"
    setup_file_permissions
    install_zsh
    setup_ssh
    install_powershell
    install_azure_cli
    install_kubectl
    install_dotnet
    install_nvm_node
    install_jq
    check_docker
    configure_git
    create_aliases
    create_git_aliases
    print_msg "Setup complete! All changes applied."
}

main
