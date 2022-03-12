<img src="https://raw.githubusercontent.com/MicaelliMedeiros/micaellimedeiros/master/image/computer-illustration.png" min-width="400px" max-width="400px" width="300px" align="right" alt="Computador">

# Configuração do meu ambiente

## VSCode
Clique [aqui](https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64), para baixar o arquivo .deb.

## Bekeeper Studio
Clique [aqui](https://www.beekeeperstudio.io/).

## Insomnia
Clique [aqui](https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website), para baixar o arquivo .deb.

## MySQL WorkBench
Vamos começar com esse link, e baixar as coisas a seguir:
[Workbench](https://dev.mysql.com/downloads/workbench/)

## NVM
Comando de instalação

`wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash`

## Node
Para instalar uma versão específica:

`nvm install vX.X.X`

Para desinstalar uma versão específica:

`nvm uninstall vX.X.X`

Para usar uma versão específica:

`nvm use vX.X.X`

Para listar versões instaladas:

`nvm ls`

Para listar versões disponíveis para download:

`nvm ls-remote`

## Deluge

`sudo add-apt-repository ppa:deluge-team/stable`

`sudo apt-get update`

`sudo apt-get install deluge`

## Redis-Server

```
sudo apt update
sudo apt install redis-server
sudo systemctl restart redis.service
```

Para ver o status do serviço:

`sudo systemctl status redis`

## Docker
Primeiro, vamos instalá-lo, junto com o que ele necessita.
```
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
```

Instalando o docker-compose:

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```

Agora, vamos checar se ele está rodando:

`sudo systemctl status docker`

Vamos configurar o linux para rodar ele sem o sudo:

```
sudo usermod -aG docker ${USER}
su - ${USER}
```

Vamos confirmar se o usuário está adicionado ao grupo do docker:

`id -nG`

Se precisar, é possível adicioná-lo com esse comando:

`sudo usermod -aG docker username`


Que tal testarmos com um hello world:

`docker run hello-world`


### Setando consumo de RAM
Primeiro vamos ver a configuração do docker:

`sudo docker info`

Agora vamos editar o arquivo de configuração grub:

`sudo nano /etc/default/grub`

Adicione a seguinte linha ao arquivo:

`GRUB_CMDLINE_LINUX="cdgroup_enable=memory swapaccount=1"`

Salve e depois rode o seguinte comando:

`sudo update-grub`

Configurar network

`docker network create icv-network`

Reinicie sua máquina

### Setando o consumo de memória para uma imagem

Use o seguinte comando:

`sudo docker run -it --memory="[memory_limit]" --memory-swap="[memory_limit]" [docker_image]`

Exemplo:

`sudo docker run -it --memory="1g" --memory-swap="2g" ubuntu`

## HTTP Toolkit
Clique [aqui](https://httptoolkit.tech/download/linux-deb/), para baixar.

## Cloudflared
Clique [aqui](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation), para baixar.

## Filezilla

```
sudo add-apt-repository ppa:sicklylife/filezilla

sudo apt-get update

sudo apt-get install filezilla
```

## Peek

`flatpak install --from https://flathub.org/repo/appstream/com.uploadedlobster.peek.flatpakref`

# Personalização

## Personalização do GNOME
[Clique](https://www.youtube.com/watch?v=S07IwKI5xH0), para personalisar o GNOME.

### Temas que eu uso
- Sweet
- Tela icon circle
- WhiteSur

### Extensões que eu uso
- Blur my shell ON
- System-Monitor ON

#### Programas para  workflow
- [Touchegg](https://github.com/JoseExposito/touchegg/releases/download/2.0.12/touchegg_2.0.12_amd64.deb)
- [Touché](https://flathub.org/apps/details/com.github.joseexposito.touche)

### Teminal
Clique [aqui](https://blog.rocketseat.com.br/terminal-com-oh-my-zsh-spaceship-dracula-e-mais/).

## Etc e tal

### Jogos 
- Snes9x
 ```bash
 flatpak install --from https://flathub.org/repo/appstream/com.snes9x.Snes9x.flatpakref
flatpak --user update com.snes9x.Snes9x
 ```
 - [Jogos do SNES](https://drive.google.com/drive/folders/1oKNqTVjtzIUsTnKq0tUkPKmSZgvgq2II?usp=sharing)
- Lutris
```bash
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt update
sudo apt install lutris
```
- [Epic Store](https://lutris.net/games/epic-games-store/)
### ScreenCast
- Kazam 
```bash
sudo add-apt-repository ppa:kazam-team/stable-series
sudo apt-get update
sudo apt-get install kazam

```
