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
  sudo chmod +x ./dotfiles/installDev.sh
  sudo chmod +x ./dotfiles/installAll.sh
fi

echo -e "\n\e[1;35m ########### Removing old files... ########### \n\e[0m"
if [[ -e ".zshrc" ]]; then
  echo -e "\e[1;35m Removing .zshrc \e[0m"
  rm ~/.zshrc
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
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.config/nvim ~/.config
ln -s ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
