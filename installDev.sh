#!/bin/bash
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
echo -e "\n\e[1;32m ########### Instaling Plug ########### \n\e[0m"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg   lsb-release
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 
# Install Docker Compose
echo -e "\n\e[1;32m ########### Instaling Docker Compose ########### \n\e[0m"
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
 chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
