# 📂 dotfiles

Here are some of my linux config files and automatize the instalation of my apps. 
To init the environment configuration run `init.sh`.

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

![Captura de tela de 2023-01-11 19-05-35](https://user-images.githubusercontent.com/79997705/211930496-b6db41d9-90da-4a28-b59d-c75a2227b927.png)

## My Tmux and Oh My Zsh

It shows:
 - BTC price;
 - USD price;
 - Current song playng;
 - CPU usage;
 - RAM usage;

![Captura de tela de 2023-01-11 19-03-54](https://user-images.githubusercontent.com/79997705/211930470-4b12eafd-c8c7-4995-aac6-6c700b623724.png)




