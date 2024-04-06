# 📂 dotfiles

Here are some of my linux config files and automatize the instalation of my apps. 
To apply the environment configuration run the command bellow:

~~~bash
wget -qO- https://raw.githubusercontent.com/NathanFirmo/dotfiles/main/init.sh | bash
~~~

## My NeoVim

You can test inside a docker container just using this command:

~~~bash
docker run -w /root -it --rm alpine:edge sh -uelic '
    apk add git nodejs neovim ripgrep alpine-sdk --update
    git clone https://github.com/NathanFirmo/dotfiles          
    cp -r dotfiles/.config .config
    git clone --depth 1 https://github.com/wbthomason/packer.nvim .local/share/nvim/site/pack/packer/start/packer.nvim
    nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync"
    nvim
'
 ~~~

![2024-01-02_21-50](https://github.com/NathanFirmo/dotfiles/assets/79997705/2e739d21-1605-44b3-a559-e877530330e6)

## My Zsh

![2024-04-06_11-17](https://github.com/NathanFirmo/dotfiles/assets/79997705/b0a0b1c7-1a45-4563-86a4-93a2f0782cc4)

