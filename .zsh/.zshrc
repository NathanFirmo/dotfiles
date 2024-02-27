source ~/.zsh/env-vars.zsh
source ~/.zsh/zinit.zsh

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

source ~/.zsh/compdef/kubectl.zsh
source ~/.zsh/compdef/kind.zsh

source ~/.zsh/aliases.zsh

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# # The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/nathan/pkg/google-cloud-sdk/path.zsh.inc' ]; then . '/home/nathan/pkg/google-cloud-sdk/path.zsh.inc'; fi

# # The next line enables shell command completion for gcloud.
if [ -f '/home/nathan/pkg/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/nathan/pkg/google-cloud-sdk/completion.zsh.inc'; fi

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
