export GPG_TTY=/dev/pts/1

# Path to your oh-my-zsh installation.
export ZSH="/home/nathan/.oh-my-zsh"
export EDITOR=hx

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

export NVM_DIR=~/.nvm
 [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# pnpm
export PNPM_HOME="/home/nathan/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Created by `pipx` on 2023-04-21 16:38:20
export PATH="$PATH:/home/nathan/.local/bin:/home/linuxbrew/.linuxbrew/bin"

export GOPATH="/home/nathan/go"
export GOBIN="/home/nathan/go/bin"
export PATH="PATH=$PATH:$GOBIN"
export OPENSSL_CONF="/dev/null"
