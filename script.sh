#!/bin/bash

 # Remove old files and create symbolic links

echo "Removing old files..."

cd
if [[ -e ".zshrc" ]]; then
  rm ~/.zshrc
fi

if [[ -e ".tmux.conf" ]]; then
  rm ~/.tmux.conf
fi

# ~/.config
cd .config
if [[ -d "coc" ]]; then
  rm -rf ~/.config/coc
fi

if [[ -d "nvim" ]]; then
  rm -rf ~/.config/nvim
fi

if [[ -d "vimspector-config" ]]; then
  rm -rf ~/.config/vimspector-config
fi

echo "Creating symbolic links..."

ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
# ln -s ~/dotfiles/.config/coc ~/.config
 ln -s ~/dotfiles/.config/nvim ~/.config
 ln -s ~/dotfiles/.config/vimspector-onfig ~/.config
