#!/bin/bash

# Get user confirmation
echo See the complete script at https://github.com/NathanFirmo/dotfiles/blob/main/init.sh
echo -e -n "\e[1;32mThis script will install some programs and move file. Are you sure to continue? y/n  \e[0m"
read -r usr_response
if [[ $usr_response == 'y' ]]; then
  sudo echo -e "\n\e[1;32mInitializing process\e[0m"
else
  exit 1
fi

# Install git
echo -e "\n\e[1;32mInstaling git\e[0m"
sudo apt install git -y

cd

# Clone repo
if [[ -e "dotfiles" ]]; then
  echo -e "\n\e[1;32mdotfiles folder already exists\e[0m"
else
  echo -e "\n\e[1;32mCloning repo\e[0m"
  git clone https://github.com/NathanFirmo/dotfiles.git
fi

# Install snap
echo -e "\n\e[1;32mInstaling snap\e[0m"
sudo apt install snapd -y

# Install GitHub CLI
echo -e "\n\e[1;32mInstaling GitHub CLI\e[0m"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

# Install neovim
echo -e "\n\e[1;32mInstaling Neovim\e[0m"
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen -y
cd
if [[ -e "neovim" ]]; then
  echo -e "\n\e[1;32mFetching repo\e[0m"
  git pull
else
  echo -e "\n\e[1;32mCloning repo\e[0m"
  git clone https://github.com/neovim/neovim
fi
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd

# Install Docker
echo -e "\n\e[1;32mInstaling Docker\e[0m"
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
echo -e "\n\e[1;32mInstaling Docker Compose\e[0m"
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
 chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# Remove old files
echo -e "\n\e[1;32mRemoving old files...\e[0m"
if [[ -e ".zshrc" ]]; then
  mv ~/.zshrc ~/.zshrc-old
fi
if [[ -e ".p10k.zsh" ]]; then
  mv ~/.p10k.zsh ~/.p10k.zsh-old
fi
if [[ -e ".tmux.conf" ]]; then
  mv ~/.tmux.conf ~/.tmux.conf-old
fi
if [[ -h ".gitconfig" ]]; then
  mv ~/.gitconfig ~/.gitconfig-old
fi
if [[ -h ".gitignore" ]]; then
  mv ~/.gitignore ~/.gitignore-old
fi
[ -h /usr/bin/nvim ] && sudo rm /usr/bin/nvim
cd .config
if [[ -d "nvim" ]]; then
  mv ~/.config/nvim ~/.config/nvim-old
fi

echo -e "\n\e[1;32mCreating symbolic links...\e[0m"
echo -e "Linking .zshrc"
echo -e "Linking nvim config"
echo -e "Linking git config"
echo -e "Linking gitignore"
echo -e "Linking power level 10k config"
echo -e "Linking tmux config"
echo -e "Linking nvim binary"
ln -s ~/dotfiles/.gitconfig-base ~/.gitconfig
ln -s ~/dotfiles/.gitignore-global ~/.gitignore
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.config/nvim ~/.config
ln -s ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
sudo ln -s ~/neovim/build/bin/nvim /usr/bin
