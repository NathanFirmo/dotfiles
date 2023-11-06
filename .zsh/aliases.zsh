## Aliases ###

unalias -a
alias v2a="cd ~/work/v2/api"
alias v2f="cd ~/work/v2/frontend"
alias icvw="~/work/v3/monorepo"
alias v3DbUp="docker compose -f ~/work/v3/monorepo/.local/docker-compose.yml up -d mysql-db mongo-db rabbitmq redis"
alias v3DbDown="docker compose -f ~/work/v3/monorepo/.local/docker-compose.yml down"
alias ys="yarn start"
alias yd="yarn dev"
alias gs="git status"
alias gc="git commit -m "
alias gp="git pull --rebase --autostash && git push"
alias gss="git stash save"
alias gsa="git stash apply"
alias gsl="git stash list"
alias gdiff="git difftool -y --no-symlinks"
alias gl="git log --oneline --decorate --graph --all"
alias azrun="az aks command invoke --resource-group k8s --name dev --command"
alias swagger2http="node ~/projects/swagger2http/index.js"
alias mic="amixer sset Capture"
alias volume="amixer sset Master"
alias l="/usr/bin/nnn -deaH"
alias ls="/usr/bin/ls --color=auto -la"
alias copy="xclip -sel clip"
alias luamake="/home/nathan/lua-language-server/3rd/luamake/luamake"
alias c='clear'
alias grep='grep --color=auto'

## Functions ###

function ga() {
  if [[ $* == '' ]] then
    git add .
  else
    for word in "$@"; do 
      git status | grep "$word" | awk '{ print $NF }' | xargs git add
    done 
  fi
}
