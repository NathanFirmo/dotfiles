source ~/.zsh/env-vars.zsh
source ~/.zsh/zinit.zsh
source ~/.zsh/zoxide.zsh
source $ZSH/oh-my-zsh.sh
. "$HOME/.cargo/env"

eval "$(rbenv init - zsh)"

source ~/.zsh/compdef/kubectl.zsh

source ~/.zsh/aliases.zsh

export PATH="/home/linuxbrew/.linuxbrew/opt/mysql-client/bin:$PATH"
source "$HOME/.dotbins/shell/zsh.sh"

export CLOUDSDK_ROOT_DIR=/opt/google-cloud-cli
export CLOUDSDK_PYTHON=/usr/bin/python
export CLOUDSDK_PYTHON_ARGS='-S -W ignore'
export PATH=$CLOUDSDK_ROOT_DIR/bin:$PATH
export GOOGLE_CLOUD_SDK_HOME=$CLOUDSDK_ROOT_DIR

source /usr/share/nvm/init-nvm.sh

source <(fzf --zsh)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Keep GPG pinentry attached to the current terminal session.
export GPG_TTY=$(tty)
