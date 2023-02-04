#!/bin/bash

function logStep() {
  echo -e "\n\e[1;32m$1\e[0m"
}

logStep "Initializing process"

logStep "Instaling git"
sudo apt install git -y

cd

if [[ -e "dotfiles" ]]; then
  logStep "dotfiles folder already exists"
else
  logStep "Cloning dotfiles"
  git clone https://github.com/NathanFirmo/dotfiles.git
fi

if [[ -e ".local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
  logStep "Packer.nvim already exists"
else
  logStep "Cloning packer.nvim"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim .local/share/nvim/site/pack/packer/start/packer.nvim
fi

logStep "Instaling GitHub CLI"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

logStep "Instaling dependencies to build NeoVim"
sudo apt install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen -y
cd
if [[ -e "neovim" ]]; then
logStep "Fetching NeoVim repo"
  git pull
else
  logStep "Cloning NeoVim repo"
  git clone https://github.com/neovim/neovim
fi
logStep "Building NeoVim repo"
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd

logStep "Instaling Docker"
sudo apt update
sudo apt install \
    ca-certificates \
    curl \
    gnupg \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg   lsb-release
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

logStep "Instaling Docker Compose"
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
 chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

logStep "Renaming old files..."
mv ~/.zshrc ~/.zshrc-old
mv ~/.p10k.zsh ~/.p10k.zsh-old
mv ~/.tmux.conf ~/.tmux.conf-old
mv ~/.gitconfig ~/.gitconfig-old
mv ~/.gitignore ~/.gitignore-old
[ -h /usr/bin/nvim ] && sudo rm /usr/bin/nvim
[ -h /usr/bin/v ] && sudo rm /usr/bin/v
[ -h /usr/local/bin/nvim ] && sudo rm /usr/local/bin/nvim
cd .config
mv ~/.config/nvim ~/.config/nvim-old
cd
mv ./WhiteSur-gtk-theme ~/.themes
mv ./WhiteSur-icon-theme/ ~/.icons

logStep "Creating symbolic links..."
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
sudo ln -s ~/neovim/build/bin/nvim /usr/bin/v

nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync"

logStep "Installing Space Mono Nerd Font"
cp ~/dotfiles/fonts/Space\ Mono\ Nerd\ Font\ Complete\ Mono.ttf ~/.local/share/fonts

logStep "Installing nvm"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

logStep "Instaling NodeJS"
nvm install 16.16
nvm use 16.16

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

logStep "Instaling C language server"
sudo apt install clangd-12
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100

logStep "Instaling Tidy"
wget -O tidy.deb https://github.com/htacg/tidy-html5/releases/download/5.8.0/tidy-5.8.0-Linux-64bit.deb
sudo dpkg -i tidy.deb
rm tidy.deb

logStep "Instaling RipGrep"
RIPGREP_VERSION=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep -Po '"tag_name": "\K[0-9.]+')
wget -O ripgrep.deb "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep_${RIPGREP_VERSION}_amd64.deb"
sudo dpkg -i ./ripgrep.deb
rm -rf ripgrep.deb

logStep "Instaling snap"
sudo apt install snapd -y

logStep "Instaling dbeaver-ce"
sudo snap install dbeaver-ce

logStep "Instaling helm"
sudo snap install helm

logStep "Instaling mysql-workbench-community"
sudo snap install mysql-workbench-community

logStep "Instaling redis-desktop-manager"
sudo snap install redis-desktop-manager

logStep "Instaling Insomnia"
wget -O insomnia.deb https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website
sudo dpkg -i ./insomnia.deb -y
rm insomnia.deb

logStep "Instaling qbittorrent"
sudo apt install qbittorrent -y

logStep "Instaling Google Chrome Dev"
wget -O chrome.deb https://dl.google.com/linux/direct/google-chrome-unstable_current_amd64.deb
sudo dpkg -i ./chrome.deb -y
rm chrome.deb

logStep "Instaling SoapUI"
wget https://s3.amazonaws.com/downloads.eviware/soapuios/5.7.0/SoapUI-x64-5.7.0.sh
sudo chmod +x ./SoapUI-x64-5.7.0.sh
./SoapUI-x64-5.7.0.sh

logStep "Instaling MiniKube"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
rm minikube_latest_amd64.deb

logStep "Instaling GCloud CLI"
sudo apt install apt-transport-https ca-certificates gnupg -y
echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update && sudo apt install google-cloud-cli

logStep "Instaling Filezilla"
sudo add-apt-repository ppa:sicklylife/filezilla
sudo apt update
sudo apt install filezilla -y

logStep "Instaling MongoDB Compass"
wget -O mongodb-compass.deb https://downloads.mongodb.com/compass/mongodb-compass_1.35.0_amd64.deb
sudo dpkg -i ./mongodb.deb
rm mongodb-compass.deb

logStep "Instaling HeroicGamesLauncher"
sudo apt install flatpak
flatpak install flathub com.heroicgameslauncher.hgl

logStep "Instaling Kazam"
sudo add-apt-repository ppa:kazam-team/stable-series
sudo apt update
sudo apt install kazam

logStep "Instaling Electrum"
wget -O electrum https://download.electrum.org/4.3.4/electrum-4.3.4-x86_64.AppImage

logStep "Instaling Bitwarden"
wget -O bitwarden https://vault.bitwarden.com/download/?app=desktop&platform=linux

logStep "Instaling Azure CLI"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

logStep "Entering in the Matrix"
sudo apt install cmatrix -y
cmatrix
