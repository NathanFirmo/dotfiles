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

![image](https://user-images.githubusercontent.com/79997705/213598659-b49db734-6efb-4f43-9d30-9de1460587b5.png)

## My Zsh

![image](https://user-images.githubusercontent.com/79997705/213598711-cb9c61c0-9c5d-4869-a7da-fa101f170c34.png)
