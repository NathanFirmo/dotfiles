## Aliases ###

unalias -a
alias v2a="cd ~/work/main/v2/api"
alias v2f="cd ~/work/main/v2/frontend"
alias icvw="~/work/main/v3/monorepo"
alias ys="yarn start"
alias yd="yarn dev"
alias gs="git status"
alias gc="git commit -m "
alias gp="git pull --rebase --autostash && git push"
alias gss="git stash save"
alias gsa="git stash apply"
alias gsl="git stash list"
alias gd="git diff"
alias gl="git log --oneline --decorate --graph --all"
alias glp="git log -p"
alias gb="git blame"
alias lg="lazygit"
alias azrun="az aks command invoke --resource-group k8s --name dev --command"
alias swagger2http="node ~/projects/swagger2http/index.js"
alias mic="amixer sset Capture"
alias volume="amixer sset Master"
alias ls="/usr/bin/ls --color=auto -la"
alias copy="xclip -sel clip"
alias cpwd="pwd | xclip -sel clip"
alias luamake="/home/nathan/lua-language-server/3rd/luamake/luamake"
alias c='clear'
alias grep='grep --color=auto'
alias docker-up='systemctl start docker.socket'
alias docker-down='systemctl stop docker.socket'
alias bt-on='systemctl start bluetooth'
alias bt-off='systemctl stop bluetooth'

## Functions ###

l () {
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn -deaH "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
}

function ga() {
  if [[ $* == '' ]] then
    git add .
  else
    for word in "$@"; do 
      git status | grep "$word" | awk '{ print $NF }' | xargs git add
    done 
  fi
}
