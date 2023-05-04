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

![image](https://user-images.githubusercontent.com/79997705/236260823-7ea8a9b8-5d14-42f1-b436-ab52a9c5513e.png)

![Captura de tela de 2023-05-04 12-44-10](https://user-images.githubusercontent.com/79997705/236260524-b6621e09-193d-4016-aa6a-27df48ba7b7b.png)

## My Zsh

![image](https://user-images.githubusercontent.com/79997705/236261599-3345ce25-5c73-4f6c-aedc-48fcc6c43fdf.png)
