#!/bin/bash
echo "Removing old files..."
cd
if [[ -e ".zshrc" ]]; then
  rm ~/.zshrc
fi

# ~/.config
cd .config
if [[ -d "nvim" ]]; then
  rm -rf ~/.config/nvim
fi

echo "Creating symbolic links..."

ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.config/nvim ~/.config