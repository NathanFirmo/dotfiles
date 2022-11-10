#!/bin/bash

# Install git
echo -e "\n\e[1;32m ########### Instaling git ########### \n\e[0m"
sudo apt install git -y

cd

# Clone repo
if [[ -e "dotfiles" ]]; then
  echo -e "\n\e[1;32m ########### dotfiles folder already exists ########### \n\e[0m"
else
  echo -e "\n\e[1;32m ########### Cloning repo ########### \n\e[0m"
  git clone https://github.com/NathanFirmo/dotfiles.git

fi

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
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen -y
cd
if [[ -e "neovim" ]]; then
  echo -e "\n\e[1;32m ########### Fetching repo ########### \n\e[0m"
  git pull
else
  echo -e "\n\e[1;32m ########### Cloning repo ########### \n\e[0m"
  git clone https://github.com/neovim/neovim
fi
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd

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
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose
echo -e "\n\e[1;32m ########### Instaling Docker Compose ########### \n\e[0m"
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
 chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

echo -e "\n\e[1;35m ########### Removing old files... ########### \n\e[0m"
if [[ -e ".zshrc" ]]; then
  echo -e "\e[1;35m Removing .zshrc \e[0m"
  rm ~/.zshrc
fi
if [[ -e ".zshrc" ]]; then
  echo -e "\e[1;35m Removing .config \e[0m"
  rm ~/.config
fi
if [[ -e ".zshrc" ]]; then
  echo -e "\e[1;35m Removing .p10k.zsh \e[0m"
  rm ~/.p10k.zsh
fi
if [[ -e ".zshrc" ]]; then
  echo -e "\e[1;35m Removing .tmux.conf \e[0m"
  rm ~/.tmux.conf
fi

# ~/.config
cd .config
if [[ -d "nvim" ]]; then
  echo -e "\e[1;35m Removing nvim  \e[0m"
  rm -rf ~/.config/nvim
fi

echo -e "\n\e[1;32m ########### Creating symbolic links... ########### \n\e[0m"
echo -e "\e[1;32m Linking .zshrc \e[0m"
echo -e "\e[1;32m Linking nvim config \e[0m"
echo -e "\e[1;32m Linking git config \e[0m"
echo -e "\e[1;32m Linking gitignore \e[0m"
echo -e "\e[1;32m Linking power level 10k config \e[0m"
echo -e "\e[1;32m Linking tmux config \e[0m"
echo -e "\e[1;32m Linking nvim binary \e[0m"
ln -s ~/dotfiles/.gitconfig-base ~/.gitconfig
ln -s ~/dotfiles/.gitignore-global ~/.gitignore
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.config/nvim ~/.config
ln -s ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
sudo ln -s ~/neovim/build/bin/nvim /usr/bin
