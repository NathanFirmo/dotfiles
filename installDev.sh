#!/bin/bash
# -------------------- Install Dev Programs --------------------- #
# Install snap

# Install git
sudo apt-get update
sudo apt-get install git -y
# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y
# Install neovim
sudo apt-get install neovim -y
sudo apt-get install python-neovim -y
sudo apt-get install python3-neovim -y
# Install Chrome

# Install VSCode
# Install Bekeeper
# Install Workbench

# -------------------- Install Dev Programs --------------------- #