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

# -------------------- Install User Programs --------------------- ##!/bin/bash
# -------------------- Install Dev Programs --------------------- #
# Install snap
echo -e "\n\e[1;32m ########### Instaling snap ########### \n\e[0m"
sudo apt install snapd -y
# Install GitHub CLI
echo -e "\n\e[1;32m ########### Instaling GitHub CLI ########### \n\e[0m"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y
# Install neovim
echo -e "\n\e[1;32m ########### Instaling Neovim ########### \n\e[0m"
sudo apt-get install neovim -y
sudo apt-get install python-neovim -y
sudo apt-get install python3-neovim -y
# Install Chrome
echo -e "\n\e[1;32m ########### Instaling Chrome ########### \n\e[0m"
sudo apt install google-chrome-stable -y
# Install VSCode
echo -e "\n\e[1;32m ########### Instaling VSCode ########### \n\e[0m"
sudo apt install code
# Install Bekeeper
echo -e "\n\e[1;32m ########### Instaling Beekeeper ########### \n\e[0m"
wget --quiet -O - https://deb.beekeeperstudio.io/beekeeper.key | sudo apt-key add -
echo "deb https://deb.beekeeperstudio.io stable main" | sudo tee /etc/apt/sources.list.d/beekeeper-studio-app.list
sudo apt update
sudo apt install beekeeper-studio -y
# Install Workbench
echo -e "\n\e[1;32m ########### Instaling Workbench ########### \n\e[0m"
sudo snap install mysql-workbench-community
# Install Docker
echo -e "\n\e[1;32m ########### Instaling Docker ########### \n\e[0m"
sudo snap install docker
sudo addgroup --system docker
sudo adduser $USER docker
newgrp docker
# Install Docker Compose
echo -e "\n\e[1;32m ########### Instaling Docker Compose ########### \n\e[0m"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose