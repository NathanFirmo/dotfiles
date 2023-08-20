#!/bin/bash

function logStep() {
  echo -e "\n\e[1;32m$1\e[0m"
}

logStep "Initializing process"

# install git go 
# install yay 
# install brew
# install snap
# install flatpack
# install neovim
# install neofetch
# install docker

ln -s ~/dotfiles/.gitconfig-base ~/.gitconfig
ln -s ~/dotfiles/.gitignore-global ~/.gitignore
ln -s ~/dotfiles/.config/nvim ~/.config
ln -s ~/dotfiles/.config/i3 ~/.config
ln -s ~/dotfiles/.config/cava ~/.config
ln -s ~/dotfiles/.config/luakit ~/.config
ln -s ~/dotfiles/.config/alacritty ~/.config
ln -s ~/dotfiles/.zsh .zsh
ln -s ~/dotfiles/.zsh/.zshrc .zshrc
ln -s ~/dotfiles/.zsh/.p10k.zsh .p10k.zsh
