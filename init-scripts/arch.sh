#!/bin/bash

function logStep() {
  echo -e "\n\e[1;32m$1\e[0m"
}

function saveOld() {
  echo -e "cp $1 $1-old 2> /dev/null || true"
}

logStep "Creating symbolic links"

saveOld "~/.gitconfig"
ln -s ~/dotfiles/.gitconfig-base ~/.gitconfig

saveOld "~/.gitignore"
ln -s ~/dotfiles/.gitignore-global ~/.gitignore

saveOld "~/dotfiles/.config/nvim"
ln -s ~/dotfiles/.config/nvim ~/.config

saveOld "~/dotfiles/.config/i3"
ln -s ~/dotfiles/.config/i3 ~/.config

saveOld "~/dotfiles/.config/cava"
ln -s ~/dotfiles/.config/cava ~/.config

saveOld "~/dotfiles/.config/alacritty"
ln -s ~/dotfiles/.config/alacritty ~/.config

saveOld "~/.zsh"
ln -s ~/dotfiles/.zsh ~/.zsh

saveOld "~/.zshrc"
ln -s ~/dotfiles/.zsh/.zshrc ~/.zshrc

saveOld "~/.p10k.zsh"
ln -s ~/dotfiles/.zsh/.p10k.zsh ~/.p10k.zsh

logStep "Creating symbolic links"

cp ~/dotfiles/fonts/*  ~/.local/share/fonts

logStep "Installing yay"

sudo pacman -S git go
mkdir -p ~/pkg
cd ~/pkg
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd

logStep "Installing brew"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

logStep "Installing snap"

yay -S snapd

logStep "Installing flatpack"

yay -S snapd

logStep "Installing neovim"

sudo pacman -S neovim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

logStep "Installing neofetch"

sudo pacman -S neofetch

logStep "Installing docker (needs restart)"

sudo pacman -S docker
sudo pacman -S docker-buildx
yay -S docker-compose

logStep "Installing NodeJS"

yay -S nvm
nvm install v16.13.0
npm install -g npm@8.11.0

logStep "Instaling TypeScript language server"

npm install -g typescript typescript-language-server

logStep "Instaling HTML language server"

npm i -g vscode-langservers-extracted

logStep "Instaling Prisma language server"

npm install -g @prisma/language-server

logStep "Instaling Docker language server"

npm install -g dockerfile-language-server-nodejs

logStep "Instaling Bash language server"

npm i -g bash-language-server

logStep "Instaling Yaml language server"

npm i -g yaml-language-server

logStep "Installing noto-color-emoji-fontconfig"

yay -S noto-color-emoji-fontconfig
