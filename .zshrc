# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/nathan/.oh-my-zsh"
export NX_DAEMON=false
# export GOOGLE_APPLICATION_CREDENTIALS="/home/nathan/incentive-me-2019-a25ec95f2a99.json"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# export GOROOT="/usr/local/go"
# export GOPATH=$HOME/go

ZSH_THEME="spaceship"

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

### ALIASES ###

alias v2a="cd ~/Trabalho/Workspace/v2/v2-api"
alias v2f="cd ~/Trabalho/Workspace/v2/v2-frontend"
alias icvw="/home/nathan/Trabalho/Workspace/incentive-me"
alias api-awards-gateway="/home/nathan/Trabalho/Workspace/incentive-me && nx serve api-awards-gateway --inspect false"
alias api-awards="/home/nathan/Trabalho/Workspace/incentive-me && nx serve api-awards --inspect false"
alias api-accounts="/home/nathan/Trabalho/Workspace/incentive-me && nx serve api-accounts --inspect false"
alias api-incents="/home/nathan/Trabalho/Workspace/incentive-me && nx serve api-incents --inspect false"
alias api-tracking="/home/nathan/Trabalho/Workspace/incentive-me && nx serve api-tracking --inspect false"
alias api-bank="/home/nathan/Trabalho/Workspace/incentive-me && nx serve api-bank --inspect false"
alias api-promo="/home/nathan/Trabalho/Workspace/incentive-me && nx serve api-promo --inspect false"
alias v3DbUp="~/scripts/shell/V3_db_up.sh"
alias v3DbDown="~/scripts/shell/V3_db_down.sh"
alias icv3="~/scripts/shell/icv3/main.sh"
alias ys="yarn start"
alias yd="yarn dev"
alias gs="git status"
alias gc="git commit -m "
alias gp="git pull --rebase && git push"
alias gss="git stash save"
alias gsa="git stash apply"
alias kctl="kubectl"
unalias ga

### FUNCTIONS ###

function ga() {
  if [[ $1 == '.' ]] then
    git add .
  else
    git status | ag $1 | awk '{ print $NF }' | xargs git add
  fi
}

export PATH=/home/nathan/.nvm/versions/node/v16.13.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap
export DENO_INSTALL="/home/nathan/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_CHAR_SYMBOL="$"
SPACESHIP_CHAR_SUFFIX=" "


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit ice depth=1; zinit light romkatv/powerlevel10k

export NVM_DIR=~/.nvm
 [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
