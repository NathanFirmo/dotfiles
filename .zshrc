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
export EDITOR=nvim
# export GOOGLE_APPLICATION_CREDENTIALS="/home/nathan/incentive-me-2019-a25ec95f2a99.json"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# export GOROOT="/usr/local/go"
# export GOPATH=$HOME/go

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

### ALIASES ###

alias v2a="cd ~/Trabalho/Workspace/v2/v2-api"
alias v2f="cd ~/Trabalho/Workspace/v2/v2-frontend"
alias icvw="/home/nathan/Trabalho/Workspace/incentive-me"
alias serve-payments="~/scripts/shell/V3_db_up.sh && nx run-many --target=serve --projects=ui-payments,api-accounts,api-organizations,api-graph,api-permissions,api-storage,api-payments --parallel --maxParallel=100 --inspect=false -c ssl"
alias serve-hq="~/scripts/shell/V3_db_up.sh && nx run-many --target=serve --projects=ui-headquarter,api-accounts,api-organizations,api-graph,api-permissions --parallel --maxParallel=100 --inspect=false -c ssl"
alias v3DbUp="docker compose -f ~/Trabalho/Workspace/incentive-me/.local/docker-compose.yml up -d"
alias v3DbDown="docker compose -f ~/Trabalho/Workspace/incentive-me/.local/docker-compose.yml down"
alias ys="yarn start"
alias yd="yarn dev"
alias gs="git status"
alias gc="git commit -m "
alias gp="git pull --rebase --autostash && git push"
alias gss="git stash save"
alias gsa="git stash apply"
alias gsl="git stash list"
alias minikubectl="minikube kubectl --"
alias gdiff="git difftool -y --no-symlinks"
alias gl="git log --pretty=format:\"%h - %an, %ar: %s\""
alias azrun="az aks command invoke --resource-group k8s --name dev --command"
alias swagger2http="node ~/Projetos/swagger2http/index.js"
alias v="nvim"
alias chat="shell-genie ask"
alias samsung-monitor-brightness="xrandr --output HDMI-A-0 --brightness"
alias notebook-monitor-brightness="xrandr --output eDP --brightness"
unalias ga

### Functions ###

function ga() {
  if [[ $* == '' ]] then
    git add .
  else
    for word in "$@"; do 
      git status | ag "$word" | awk '{ print $NF }' | xargs git add
    done 
  fi
}

### End of functions

export GOROOT="/usr/local/go"
export GOPATH=$HOME/go
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

export PATH=/home/nathan/.nvm/versions/node/v16.13.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap:$GOPATH/bin:$GOROOT/bin:/home/nathan/lua-language-server/bin

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

#compdef kubectl
compdef _kubectl kubectl

# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#compdef _kubectl kubectl

# zsh completion for kubectl                              -*- shell-script -*-

__kubectl_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_kubectl()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace
    local -a completions

    __kubectl_debug "\n========= starting completion logic =========="
    __kubectl_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __kubectl_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __kubectl_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., kubectl -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __kubectl_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __kubectl_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __kubectl_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __kubectl_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __kubectl_debug "No directive found.  Setting do default"
        directive=0
    fi

    __kubectl_debug "directive: ${directive}"
    __kubectl_debug "completions: ${out}"
    __kubectl_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __kubectl_debug "Completion received error. Ignoring completions."
        return
    fi

    while IFS='\n' read -r comp; do
        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab=$(printf '\t')
            comp=${comp//$tab/:}

            __kubectl_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __kubectl_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __kubectl_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subDir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __kubectl_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __kubectl_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __kubectl_debug "Calling _describe"
        if eval _describe "completions" completions $flagPrefix $noSpace; then
            __kubectl_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __kubectl_debug "_describe did not find completions."
            __kubectl_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __kubectl_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __kubectl_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_kubectl" ]; then
	_kubectl
fi

alias luamake=/home/nathan/lua-language-server/3rd/luamake/luamake
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# To customize prompt, run `p10k configure` or edit ~/dotfiles/.p10k.zsh.
[[ ! -f ~/dotfiles/.p10k.zsh ]] || source ~/dotfiles/.p10k.zsh

# pnpm
export PNPM_HOME="/home/nathan/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

#compdef ngrok

# zsh completion for ngrok                                -*- shell-script -*-

__ngrok_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_ngrok()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace
    local -a completions

    __ngrok_debug "\n========= starting completion logic =========="
    __ngrok_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __ngrok_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __ngrok_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., ngrok -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __ngrok_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __ngrok_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __ngrok_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __ngrok_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __ngrok_debug "No directive found.  Setting do default"
        directive=0
    fi

    __ngrok_debug "directive: ${directive}"
    __ngrok_debug "completions: ${out}"
    __ngrok_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __ngrok_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __ngrok_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __ngrok_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __ngrok_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __ngrok_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __ngrok_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __ngrok_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __ngrok_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __ngrok_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __ngrok_debug "Calling _describe"
        if eval _describe "completions" completions $flagPrefix $noSpace; then
            __ngrok_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __ngrok_debug "_describe did not find completions."
            __ngrok_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __ngrok_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __ngrok_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_ngrok" ]; then
    _ngrok
fi
compdef _ngrok ngrok

# Created by `pipx` on 2023-04-21 16:38:20
export PATH="$PATH:/home/nathan/.local/bin:/home/linuxbrew/.linuxbrew/bin"

# Zsh completions for minikube 
#compdef minikube

# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

__minikube_bash_source() {
	alias shopt=':'
	alias _expand=_bash_expand
	alias _complete=_bash_comp
	emulate -L sh
	setopt kshglob noshglob braceexpand
	source "$@"
}
__minikube_type() {
	# -t is not supported by zsh
	if [ "$1" == "-t" ]; then
		shift
		# fake Bash 4 to disable "complete -o nospace". Instead
		# "compopt +-o nospace" is used in the code to toggle trailing
		# spaces. We don't support that, but leave trailing spaces on
		# all the time
		if [ "$1" = "__minikube_compopt" ]; then
			echo builtin
			return 0
		fi
	fi
	type "$@"
}
__minikube_compgen() {
	local completions w
	completions=( $(compgen "$@") ) || return $?
	# filter by given word as prefix
	while [[ "$1" = -* && "$1" != -- ]]; do
		shift
		shift
	done
	if [[ "$1" == -- ]]; then
		shift
	fi
	for w in "${completions[@]}"; do
		if [[ "${w}" = "$1"* ]]; then
			echo "${w}"
		fi
	done
}
__minikube_compopt() {
	true # don't do anything. Not supported by bashcompinit in zsh
}
__minikube_declare() {
	if [ "$1" == "-F" ]; then
		whence -w "$@"
	else
		builtin declare "$@"
	fi
}
__minikube_ltrim_colon_completions()
{
	if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
		# Remove colon-word prefix from COMPREPLY items
		local colon_word=${1%${1##*:}}
		local i=${#COMPREPLY[*]}
		while [[ $((--i)) -ge 0 ]]; do
			COMPREPLY[$i]=${COMPREPLY[$i]#"$colon_word"}
		done
	fi
}
__minikube_get_comp_words_by_ref() {
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[${COMP_CWORD}-1]}"
	words=("${COMP_WORDS[@]}")
	cword=("${COMP_CWORD[@]}")
}
__minikube_filedir() {
	local RET OLD_IFS w qw
	__debug "_filedir $@ cur=$cur"
	if [[ "$1" = \~* ]]; then
		# somehow does not work. Maybe, zsh does not call this at all
		eval echo "$1"
		return 0
	fi
	OLD_IFS="$IFS"
	IFS=$'\n'
	if [ "$1" = "-d" ]; then
		shift
		RET=( $(compgen -d) )
	else
		RET=( $(compgen -f) )
	fi
	IFS="$OLD_IFS"
	IFS="," __debug "RET=${RET[@]} len=${#RET[@]}"
	for w in ${RET[@]}; do
		if [[ ! "${w}" = "${cur}"* ]]; then
			continue
		fi
		if eval "[[ \"\${w}\" = *.$1 || -d \"\${w}\" ]]"; then
			qw="$(__minikube_quote "${w}")"
			if [ -d "${w}" ]; then
				COMPREPLY+=("${qw}/")
			else
				COMPREPLY+=("${qw}")
			fi
		fi
	done
}
__minikube_quote() {
	if [[ $1 == \'* || $1 == \"* ]]; then
		# Leave out first character
		printf %q "${1:1}"
	else
		printf %q "$1"
	fi
}
autoload -U +X bashcompinit && bashcompinit
# use word boundary patterns for BSD or GNU sed
LWORD='[[:<:]]'
RWORD='[[:>:]]'
if sed --help 2>&1 | grep -q GNU; then
	LWORD='\<'
	RWORD='\>'
fi
__minikube_convert_bash_to_zsh() {
	sed \
	-e 's/declare -F/whence -w/' \
	-e 's/_get_comp_words_by_ref "\$@"/_get_comp_words_by_ref "\$*"/' \
	-e 's/local \([a-zA-Z0-9_]*\)=/local \1; \1=/' \
	-e 's/flags+=("\(--.*\)=")/flags+=("\1"); two_word_flags+=("\1")/' \
	-e 's/must_have_one_flag+=("\(--.*\)=")/must_have_one_flag+=("\1")/' \
	-e "s/${LWORD}_filedir${RWORD}/__minikube_filedir/g" \
	-e "s/${LWORD}_get_comp_words_by_ref${RWORD}/__minikube_get_comp_words_by_ref/g" \
	-e "s/${LWORD}__ltrim_colon_completions${RWORD}/__minikube_ltrim_colon_completions/g" \
	-e "s/${LWORD}compgen${RWORD}/__minikube_compgen/g" \
	-e "s/${LWORD}compopt${RWORD}/__minikube_compopt/g" \
	-e "s/${LWORD}declare${RWORD}/__minikube_declare/g" \
	-e "s/\\\$(type${RWORD}/\$(__minikube_type/g" \
	-e "s/aliashash\[\"\([a-z]*\)\"\]/aliashash[\1]/g" \
	<<'BASH_COMPLETION_EOF'
# bash completion for minikube                             -*- shell-script -*-

__minikube_debug()
{
    if [[ -n ${BASH_COMP_DEBUG_FILE:-} ]]; then
        echo "$*" >> "${BASH_COMP_DEBUG_FILE}"
    fi
}

# Homebrew on Macs have version 1.3 of bash-completion which doesn't include
# _init_completion. This is a very minimal version of that function.
__minikube_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref "$@" cur prev words cword
}

__minikube_index_of_word()
{
    local w word=$1
    shift
    index=0
    for w in "$@"; do
        [[ $w = "$word" ]] && return
        index=$((index+1))
    done
    index=-1
}

__minikube_contains_word()
{
    local w word=$1; shift
    for w in "$@"; do
        [[ $w = "$word" ]] && return
    done
    return 1
}

__minikube_handle_go_custom_completion()
{
    __minikube_debug "${FUNCNAME[0]}: cur is ${cur}, words[*] is ${words[*]}, #words[@] is ${#words[@]}"

    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local out requestComp lastParam lastChar comp directive args

    # Prepare the command to request completions for the program.
    # Calling ${words[0]} instead of directly minikube allows to handle aliases
    args=("${words[@]:1}")
    # Disable ActiveHelp which is not supported for bash completion v1
    requestComp="MINIKUBE_ACTIVE_HELP=0 ${words[0]} __completeNoDesc ${args[*]}"

    lastParam=${words[$((${#words[@]}-1))]}
    lastChar=${lastParam:$((${#lastParam}-1)):1}
    __minikube_debug "${FUNCNAME[0]}: lastParam ${lastParam}, lastChar ${lastChar}"

    if [ -z "${cur}" ] && [ "${lastChar}" != "=" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __minikube_debug "${FUNCNAME[0]}: Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __minikube_debug "${FUNCNAME[0]}: calling ${requestComp}"
    # Use eval to handle any environment variables and such
    out=$(eval "${requestComp}" 2>/dev/null)

    # Extract the directive integer at the very end of the output following a colon (:)
    directive=${out##*:}
    # Remove the directive
    out=${out%:*}
    if [ "${directive}" = "${out}" ]; then
        # There is not directive specified
        directive=0
    fi
    __minikube_debug "${FUNCNAME[0]}: the completion directive is: ${directive}"
    __minikube_debug "${FUNCNAME[0]}: the completions are: ${out}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        # Error code.  No completion.
        __minikube_debug "${FUNCNAME[0]}: received error from custom completion go code"
        return
    else
        if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
            if [[ $(type -t compopt) = "builtin" ]]; then
                __minikube_debug "${FUNCNAME[0]}: activating no space"
                compopt -o nospace
            fi
        fi
        if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
            if [[ $(type -t compopt) = "builtin" ]]; then
                __minikube_debug "${FUNCNAME[0]}: activating no file completion"
                compopt +o default
            fi
        fi
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local fullFilter filter filteringCmd
        # Do not use quotes around the $out variable or else newline
        # characters will be kept.
        for filter in ${out}; do
            fullFilter+="$filter|"
        done

        filteringCmd="_filedir $fullFilter"
        __minikube_debug "File filtering command: $filteringCmd"
        $filteringCmd
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        # Use printf to strip any trailing newline
        subdir=$(printf "%s" "${out}")
        if [ -n "$subdir" ]; then
            __minikube_debug "Listing directories in $subdir"
            __minikube_handle_subdirs_in_dir_flag "$subdir"
        else
            __minikube_debug "Listing directories in ."
            _filedir -d
        fi
    else
        while IFS='' read -r comp; do
            COMPREPLY+=("$comp")
        done < <(compgen -W "${out}" -- "$cur")
    fi
}

__minikube_handle_reply()
{
    __minikube_debug "${FUNCNAME[0]}"
    local comp
    case $cur in
        -*)
            if [[ $(type -t compopt) = "builtin" ]]; then
                compopt -o nospace
            fi
            local allflags
            if [ ${#must_have_one_flag[@]} -ne 0 ]; then
                allflags=("${must_have_one_flag[@]}")
            else
                allflags=("${flags[*]} ${two_word_flags[*]}")
            fi
            while IFS='' read -r comp; do
                COMPREPLY+=("$comp")
            done < <(compgen -W "${allflags[*]}" -- "$cur")
            if [[ $(type -t compopt) = "builtin" ]]; then
                [[ "${COMPREPLY[0]}" == *= ]] || compopt +o nospace
            fi

            # complete after --flag=abc
            if [[ $cur == *=* ]]; then
                if [[ $(type -t compopt) = "builtin" ]]; then
                    compopt +o nospace
                fi

                local index flag
                flag="${cur%=*}"
                __minikube_index_of_word "${flag}" "${flags_with_completion[@]}"
                COMPREPLY=()
                if [[ ${index} -ge 0 ]]; then
                    PREFIX=""
                    cur="${cur#*=}"
                    ${flags_completion[${index}]}
                    if [ -n "${ZSH_VERSION:-}" ]; then
                        # zsh completion needs --flag= prefix
                        eval "COMPREPLY=( \"\${COMPREPLY[@]/#/${flag}=}\" )"
                    fi
                fi
            fi

            if [[ -z "${flag_parsing_disabled}" ]]; then
                # If flag parsing is enabled, we have completed the flags and can return.
                # If flag parsing is disabled, we may not know all (or any) of the flags, so we fallthrough
                # to possibly call handle_go_custom_completion.
                return 0;
            fi
            ;;
    esac

    # check if we are handling a flag with special work handling
    local index
    __minikube_index_of_word "${prev}" "${flags_with_completion[@]}"
    if [[ ${index} -ge 0 ]]; then
        ${flags_completion[${index}]}
        return
    fi

    # we are parsing a flag and don't have a special handler, no completion
    if [[ ${cur} != "${words[cword]}" ]]; then
        return
    fi

    local completions
    completions=("${commands[@]}")
    if [[ ${#must_have_one_noun[@]} -ne 0 ]]; then
        completions+=("${must_have_one_noun[@]}")
    elif [[ -n "${has_completion_function}" ]]; then
        # if a go completion function is provided, defer to that function
        __minikube_handle_go_custom_completion
    fi
    if [[ ${#must_have_one_flag[@]} -ne 0 ]]; then
        completions+=("${must_have_one_flag[@]}")
    fi
    while IFS='' read -r comp; do
        COMPREPLY+=("$comp")
    done < <(compgen -W "${completions[*]}" -- "$cur")

    if [[ ${#COMPREPLY[@]} -eq 0 && ${#noun_aliases[@]} -gt 0 && ${#must_have_one_noun[@]} -ne 0 ]]; then
        while IFS='' read -r comp; do
            COMPREPLY+=("$comp")
        done < <(compgen -W "${noun_aliases[*]}" -- "$cur")
    fi

    if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
        if declare -F __minikube_custom_func >/dev/null; then
            # try command name qualified custom func
            __minikube_custom_func
        else
            # otherwise fall back to unqualified for compatibility
            declare -F __custom_func >/dev/null && __custom_func
        fi
    fi

    # available in bash-completion >= 2, not always present on macOS
    if declare -F __ltrim_colon_completions >/dev/null; then
        __ltrim_colon_completions "$cur"
    fi

    # If there is only 1 completion and it is a flag with an = it will be completed
    # but we don't want a space after the =
    if [[ "${#COMPREPLY[@]}" -eq "1" ]] && [[ $(type -t compopt) = "builtin" ]] && [[ "${COMPREPLY[0]}" == --*= ]]; then
       compopt -o nospace
    fi
}

# The arguments should be in the form "ext1|ext2|extn"
__minikube_handle_filename_extension_flag()
{
    local ext="$1"
    _filedir "@(${ext})"
}

__minikube_handle_subdirs_in_dir_flag()
{
    local dir="$1"
    pushd "${dir}" >/dev/null 2>&1 && _filedir -d && popd >/dev/null 2>&1 || return
}

__minikube_handle_flag()
{
    __minikube_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    # if a command required a flag, and we found it, unset must_have_one_flag()
    local flagname=${words[c]}
    local flagvalue=""
    # if the word contained an =
    if [[ ${words[c]} == *"="* ]]; then
        flagvalue=${flagname#*=} # take in as flagvalue after the =
        flagname=${flagname%=*} # strip everything after the =
        flagname="${flagname}=" # but put the = back
    fi
    __minikube_debug "${FUNCNAME[0]}: looking for ${flagname}"
    if __minikube_contains_word "${flagname}" "${must_have_one_flag[@]}"; then
        must_have_one_flag=()
    fi

    # if you set a flag which only applies to this command, don't show subcommands
    if __minikube_contains_word "${flagname}" "${local_nonpersistent_flags[@]}"; then
      commands=()
    fi

    # keep flag value with flagname as flaghash
    # flaghash variable is an associative array which is only supported in bash > 3.
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        if [ -n "${flagvalue}" ] ; then
            flaghash[${flagname}]=${flagvalue}
        elif [ -n "${words[ $((c+1)) ]}" ] ; then
            flaghash[${flagname}]=${words[ $((c+1)) ]}
        else
            flaghash[${flagname}]="true" # pad "true" for bool flag
        fi
    fi

    # skip the argument to a two word flag
    if [[ ${words[c]} != *"="* ]] && __minikube_contains_word "${words[c]}" "${two_word_flags[@]}"; then
        __minikube_debug "${FUNCNAME[0]}: found a flag ${words[c]}, skip the next argument"
        c=$((c+1))
        # if we are looking for a flags value, don't show commands
        if [[ $c -eq $cword ]]; then
            commands=()
        fi
    fi

    c=$((c+1))

}

__minikube_handle_noun()
{
    __minikube_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    if __minikube_contains_word "${words[c]}" "${must_have_one_noun[@]}"; then
        must_have_one_noun=()
    elif __minikube_contains_word "${words[c]}" "${noun_aliases[@]}"; then
        must_have_one_noun=()
    fi

    nouns+=("${words[c]}")
    c=$((c+1))
}

__minikube_handle_command()
{
    __minikube_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    local next_command
    if [[ -n ${last_command} ]]; then
        next_command="_${last_command}_${words[c]//:/__}"
    else
        if [[ $c -eq 0 ]]; then
            next_command="_minikube_root_command"
        else
            next_command="_${words[c]//:/__}"
        fi
    fi
    c=$((c+1))
    __minikube_debug "${FUNCNAME[0]}: looking for ${next_command}"
    declare -F "$next_command" >/dev/null && $next_command
}

__minikube_handle_word()
{
    if [[ $c -ge $cword ]]; then
        __minikube_handle_reply
        return
    fi
    __minikube_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"
    if [[ "${words[c]}" == -* ]]; then
        __minikube_handle_flag
    elif __minikube_contains_word "${words[c]}" "${commands[@]}"; then
        __minikube_handle_command
    elif [[ $c -eq 0 ]]; then
        __minikube_handle_command
    elif __minikube_contains_word "${words[c]}" "${command_aliases[@]}"; then
        # aliashash variable is an associative array which is only supported in bash > 3.
        if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
            words[c]=${aliashash[${words[c]}]}
            __minikube_handle_command
        else
            __minikube_handle_noun
        fi
    else
        __minikube_handle_noun
    fi
    __minikube_handle_word
}

_minikube_addons_configure()
{
    last_command="minikube_addons_configure"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_addons_disable()
{
    last_command="minikube_addons_disable"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_addons_enable()
{
    last_command="minikube_addons_enable"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--force")
    local_nonpersistent_flags+=("--force")
    flags+=("--images=")
    two_word_flags+=("--images")
    local_nonpersistent_flags+=("--images")
    local_nonpersistent_flags+=("--images=")
    flags+=("--refresh")
    local_nonpersistent_flags+=("--refresh")
    flags+=("--registries=")
    two_word_flags+=("--registries")
    local_nonpersistent_flags+=("--registries")
    local_nonpersistent_flags+=("--registries=")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_addons_images()
{
    last_command="minikube_addons_images"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_addons_list()
{
    last_command="minikube_addons_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--docs")
    flags+=("-d")
    local_nonpersistent_flags+=("--docs")
    local_nonpersistent_flags+=("-d")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_addons_open()
{
    last_command="minikube_addons_open"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--format=")
    two_word_flags+=("--format")
    flags+=("--https")
    local_nonpersistent_flags+=("--https")
    flags+=("--interval=")
    two_word_flags+=("--interval")
    local_nonpersistent_flags+=("--interval")
    local_nonpersistent_flags+=("--interval=")
    flags+=("--url")
    local_nonpersistent_flags+=("--url")
    flags+=("--wait=")
    two_word_flags+=("--wait")
    local_nonpersistent_flags+=("--wait")
    local_nonpersistent_flags+=("--wait=")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_addons()
{
    last_command="minikube_addons"

    command_aliases=()

    commands=()
    commands+=("configure")
    commands+=("disable")
    commands+=("enable")
    commands+=("images")
    commands+=("list")
    commands+=("open")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_cache_add()
{
    last_command="minikube_cache_add"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    local_nonpersistent_flags+=("--all")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_cache_delete()
{
    last_command="minikube_cache_delete"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_cache_list()
{
    last_command="minikube_cache_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--format=")
    two_word_flags+=("--format")
    local_nonpersistent_flags+=("--format")
    local_nonpersistent_flags+=("--format=")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_cache_reload()
{
    last_command="minikube_cache_reload"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_cache()
{
    last_command="minikube_cache"

    command_aliases=()

    commands=()
    commands+=("add")
    commands+=("delete")
    commands+=("list")
    commands+=("reload")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_completion_bash()
{
    last_command="minikube_completion_bash"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_completion_fish()
{
    last_command="minikube_completion_fish"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_completion_zsh()
{
    last_command="minikube_completion_zsh"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_completion()
{
    last_command="minikube_completion"

    command_aliases=()

    commands=()
    commands+=("bash")
    commands+=("fish")
    commands+=("zsh")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_config_defaults()
{
    last_command="minikube_config_defaults"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_config_get()
{
    last_command="minikube_config_get"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_config_set()
{
    last_command="minikube_config_set"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_config_unset()
{
    last_command="minikube_config_unset"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_config_view()
{
    last_command="minikube_config_view"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--format=")
    two_word_flags+=("--format")
    local_nonpersistent_flags+=("--format")
    local_nonpersistent_flags+=("--format=")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_config()
{
    last_command="minikube_config"

    command_aliases=()

    commands=()
    commands+=("defaults")
    commands+=("get")
    commands+=("set")
    commands+=("unset")
    commands+=("view")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_cp()
{
    last_command="minikube_cp"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_dashboard()
{
    last_command="minikube_dashboard"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--port=")
    two_word_flags+=("--port")
    local_nonpersistent_flags+=("--port")
    local_nonpersistent_flags+=("--port=")
    flags+=("--url")
    local_nonpersistent_flags+=("--url")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_delete()
{
    last_command="minikube_delete"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    local_nonpersistent_flags+=("--all")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--purge")
    local_nonpersistent_flags+=("--purge")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_docker-env()
{
    last_command="minikube_docker-env"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--no-proxy")
    local_nonpersistent_flags+=("--no-proxy")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--shell=")
    two_word_flags+=("--shell")
    local_nonpersistent_flags+=("--shell")
    local_nonpersistent_flags+=("--shell=")
    flags+=("--ssh-add")
    local_nonpersistent_flags+=("--ssh-add")
    flags+=("--ssh-host")
    local_nonpersistent_flags+=("--ssh-host")
    flags+=("--unset")
    flags+=("-u")
    local_nonpersistent_flags+=("--unset")
    local_nonpersistent_flags+=("-u")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_help()
{
    last_command="minikube_help"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_minikube_image_build()
{
    last_command="minikube_image_build"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    local_nonpersistent_flags+=("--all")
    flags+=("--build-env=")
    two_word_flags+=("--build-env")
    local_nonpersistent_flags+=("--build-env")
    local_nonpersistent_flags+=("--build-env=")
    flags+=("--build-opt=")
    two_word_flags+=("--build-opt")
    local_nonpersistent_flags+=("--build-opt")
    local_nonpersistent_flags+=("--build-opt=")
    flags+=("--file=")
    two_word_flags+=("--file")
    two_word_flags+=("-f")
    local_nonpersistent_flags+=("--file")
    local_nonpersistent_flags+=("--file=")
    local_nonpersistent_flags+=("-f")
    flags+=("--node=")
    two_word_flags+=("--node")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--node")
    local_nonpersistent_flags+=("--node=")
    local_nonpersistent_flags+=("-n")
    flags+=("--push")
    local_nonpersistent_flags+=("--push")
    flags+=("--tag=")
    two_word_flags+=("--tag")
    two_word_flags+=("-t")
    local_nonpersistent_flags+=("--tag")
    local_nonpersistent_flags+=("--tag=")
    local_nonpersistent_flags+=("-t")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_image_load()
{
    last_command="minikube_image_load"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--daemon")
    local_nonpersistent_flags+=("--daemon")
    flags+=("--overwrite")
    local_nonpersistent_flags+=("--overwrite")
    flags+=("--pull")
    local_nonpersistent_flags+=("--pull")
    flags+=("--remote")
    local_nonpersistent_flags+=("--remote")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_image_ls()
{
    last_command="minikube_image_ls"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--format=")
    two_word_flags+=("--format")
    local_nonpersistent_flags+=("--format")
    local_nonpersistent_flags+=("--format=")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_image_pull()
{
    last_command="minikube_image_pull"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_image_push()
{
    last_command="minikube_image_push"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_image_rm()
{
    last_command="minikube_image_rm"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_image_save()
{
    last_command="minikube_image_save"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--daemon")
    local_nonpersistent_flags+=("--daemon")
    flags+=("--remote")
    local_nonpersistent_flags+=("--remote")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_image_tag()
{
    last_command="minikube_image_tag"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_image()
{
    last_command="minikube_image"

    command_aliases=()

    commands=()
    commands+=("build")
    commands+=("load")
    commands+=("ls")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("list")
        aliashash["list"]="ls"
    fi
    commands+=("pull")
    commands+=("push")
    commands+=("rm")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("remove")
        aliashash["remove"]="rm"
        command_aliases+=("unload")
        aliashash["unload"]="rm"
    fi
    commands+=("save")
    commands+=("tag")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("list")
        aliashash["list"]="tag"
    fi

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_ip()
{
    last_command="minikube_ip"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--node=")
    two_word_flags+=("--node")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--node")
    local_nonpersistent_flags+=("--node=")
    local_nonpersistent_flags+=("-n")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_kubectl()
{
    last_command="minikube_kubectl"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--ssh")
    local_nonpersistent_flags+=("--ssh")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_license()
{
    last_command="minikube_license"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--dir=")
    two_word_flags+=("--dir")
    two_word_flags+=("-d")
    local_nonpersistent_flags+=("--dir")
    local_nonpersistent_flags+=("--dir=")
    local_nonpersistent_flags+=("-d")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_logs()
{
    last_command="minikube_logs"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--audit")
    local_nonpersistent_flags+=("--audit")
    flags+=("--file=")
    two_word_flags+=("--file")
    local_nonpersistent_flags+=("--file")
    local_nonpersistent_flags+=("--file=")
    flags+=("--follow")
    flags+=("-f")
    local_nonpersistent_flags+=("--follow")
    local_nonpersistent_flags+=("-f")
    flags+=("--last-start-only")
    local_nonpersistent_flags+=("--last-start-only")
    flags+=("--length=")
    two_word_flags+=("--length")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--length")
    local_nonpersistent_flags+=("--length=")
    local_nonpersistent_flags+=("-n")
    flags+=("--node=")
    two_word_flags+=("--node")
    local_nonpersistent_flags+=("--node")
    local_nonpersistent_flags+=("--node=")
    flags+=("--problems")
    local_nonpersistent_flags+=("--problems")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_mount()
{
    last_command="minikube_mount"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--9p-version=")
    two_word_flags+=("--9p-version")
    local_nonpersistent_flags+=("--9p-version")
    local_nonpersistent_flags+=("--9p-version=")
    flags+=("--gid=")
    two_word_flags+=("--gid")
    local_nonpersistent_flags+=("--gid")
    local_nonpersistent_flags+=("--gid=")
    flags+=("--ip=")
    two_word_flags+=("--ip")
    local_nonpersistent_flags+=("--ip")
    local_nonpersistent_flags+=("--ip=")
    flags+=("--kill")
    local_nonpersistent_flags+=("--kill")
    flags+=("--msize=")
    two_word_flags+=("--msize")
    local_nonpersistent_flags+=("--msize")
    local_nonpersistent_flags+=("--msize=")
    flags+=("--options=")
    two_word_flags+=("--options")
    local_nonpersistent_flags+=("--options")
    local_nonpersistent_flags+=("--options=")
    flags+=("--port=")
    two_word_flags+=("--port")
    local_nonpersistent_flags+=("--port")
    local_nonpersistent_flags+=("--port=")
    flags+=("--type=")
    two_word_flags+=("--type")
    local_nonpersistent_flags+=("--type")
    local_nonpersistent_flags+=("--type=")
    flags+=("--uid=")
    two_word_flags+=("--uid")
    local_nonpersistent_flags+=("--uid")
    local_nonpersistent_flags+=("--uid=")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_node_add()
{
    last_command="minikube_node_add"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--control-plane")
    local_nonpersistent_flags+=("--control-plane")
    flags+=("--delete-on-failure")
    local_nonpersistent_flags+=("--delete-on-failure")
    flags+=("--worker")
    local_nonpersistent_flags+=("--worker")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_node_delete()
{
    last_command="minikube_node_delete"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_node_list()
{
    last_command="minikube_node_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_node_start()
{
    last_command="minikube_node_start"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--delete-on-failure")
    local_nonpersistent_flags+=("--delete-on-failure")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_node_stop()
{
    last_command="minikube_node_stop"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_node()
{
    last_command="minikube_node"

    command_aliases=()

    commands=()
    commands+=("add")
    commands+=("delete")
    commands+=("list")
    commands+=("start")
    commands+=("stop")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_options()
{
    last_command="minikube_options"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_pause()
{
    last_command="minikube_pause"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all-namespaces")
    flags+=("-A")
    local_nonpersistent_flags+=("--all-namespaces")
    local_nonpersistent_flags+=("-A")
    flags+=("--namespaces=")
    two_word_flags+=("--namespaces")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--namespaces")
    local_nonpersistent_flags+=("--namespaces=")
    local_nonpersistent_flags+=("-n")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_podman-env()
{
    last_command="minikube_podman-env"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--shell=")
    two_word_flags+=("--shell")
    local_nonpersistent_flags+=("--shell")
    local_nonpersistent_flags+=("--shell=")
    flags+=("--unset")
    flags+=("-u")
    local_nonpersistent_flags+=("--unset")
    local_nonpersistent_flags+=("-u")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_profile_list()
{
    last_command="minikube_profile_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--light")
    flags+=("-l")
    local_nonpersistent_flags+=("--light")
    local_nonpersistent_flags+=("-l")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_profile()
{
    last_command="minikube_profile"

    command_aliases=()

    commands=()
    commands+=("list")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_service_list()
{
    last_command="minikube_service_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--namespace=")
    two_word_flags+=("--namespace")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--namespace")
    local_nonpersistent_flags+=("--namespace=")
    local_nonpersistent_flags+=("-n")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--format=")
    two_word_flags+=("--format")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_service()
{
    last_command="minikube_service"

    command_aliases=()

    commands=()
    commands+=("list")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    local_nonpersistent_flags+=("--all")
    flags+=("--format=")
    two_word_flags+=("--format")
    flags+=("--https")
    local_nonpersistent_flags+=("--https")
    flags+=("--interval=")
    two_word_flags+=("--interval")
    local_nonpersistent_flags+=("--interval")
    local_nonpersistent_flags+=("--interval=")
    flags+=("--namespace=")
    two_word_flags+=("--namespace")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--namespace")
    local_nonpersistent_flags+=("--namespace=")
    local_nonpersistent_flags+=("-n")
    flags+=("--url")
    local_nonpersistent_flags+=("--url")
    flags+=("--wait=")
    two_word_flags+=("--wait")
    local_nonpersistent_flags+=("--wait")
    local_nonpersistent_flags+=("--wait=")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_ssh()
{
    last_command="minikube_ssh"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--native-ssh")
    local_nonpersistent_flags+=("--native-ssh")
    flags+=("--node=")
    two_word_flags+=("--node")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--node")
    local_nonpersistent_flags+=("--node=")
    local_nonpersistent_flags+=("-n")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_ssh-host()
{
    last_command="minikube_ssh-host"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--append-known")
    local_nonpersistent_flags+=("--append-known")
    flags+=("--node=")
    two_word_flags+=("--node")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--node")
    local_nonpersistent_flags+=("--node=")
    local_nonpersistent_flags+=("-n")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_ssh-key()
{
    last_command="minikube_ssh-key"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--node=")
    two_word_flags+=("--node")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--node")
    local_nonpersistent_flags+=("--node=")
    local_nonpersistent_flags+=("-n")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_start()
{
    last_command="minikube_start"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--addons=")
    two_word_flags+=("--addons")
    local_nonpersistent_flags+=("--addons")
    local_nonpersistent_flags+=("--addons=")
    flags+=("--apiserver-ips=")
    two_word_flags+=("--apiserver-ips")
    local_nonpersistent_flags+=("--apiserver-ips")
    local_nonpersistent_flags+=("--apiserver-ips=")
    flags+=("--apiserver-name=")
    two_word_flags+=("--apiserver-name")
    local_nonpersistent_flags+=("--apiserver-name")
    local_nonpersistent_flags+=("--apiserver-name=")
    flags+=("--apiserver-names=")
    two_word_flags+=("--apiserver-names")
    local_nonpersistent_flags+=("--apiserver-names")
    local_nonpersistent_flags+=("--apiserver-names=")
    flags+=("--apiserver-port=")
    two_word_flags+=("--apiserver-port")
    local_nonpersistent_flags+=("--apiserver-port")
    local_nonpersistent_flags+=("--apiserver-port=")
    flags+=("--auto-update-drivers")
    local_nonpersistent_flags+=("--auto-update-drivers")
    flags+=("--base-image=")
    two_word_flags+=("--base-image")
    local_nonpersistent_flags+=("--base-image")
    local_nonpersistent_flags+=("--base-image=")
    flags+=("--binary-mirror=")
    two_word_flags+=("--binary-mirror")
    local_nonpersistent_flags+=("--binary-mirror")
    local_nonpersistent_flags+=("--binary-mirror=")
    flags+=("--cache-images")
    local_nonpersistent_flags+=("--cache-images")
    flags+=("--cert-expiration=")
    two_word_flags+=("--cert-expiration")
    local_nonpersistent_flags+=("--cert-expiration")
    local_nonpersistent_flags+=("--cert-expiration=")
    flags+=("--cni=")
    two_word_flags+=("--cni")
    local_nonpersistent_flags+=("--cni")
    local_nonpersistent_flags+=("--cni=")
    flags+=("--container-runtime=")
    two_word_flags+=("--container-runtime")
    local_nonpersistent_flags+=("--container-runtime")
    local_nonpersistent_flags+=("--container-runtime=")
    flags+=("--cpus=")
    two_word_flags+=("--cpus")
    local_nonpersistent_flags+=("--cpus")
    local_nonpersistent_flags+=("--cpus=")
    flags+=("--cri-socket=")
    two_word_flags+=("--cri-socket")
    local_nonpersistent_flags+=("--cri-socket")
    local_nonpersistent_flags+=("--cri-socket=")
    flags+=("--delete-on-failure")
    local_nonpersistent_flags+=("--delete-on-failure")
    flags+=("--disable-driver-mounts")
    local_nonpersistent_flags+=("--disable-driver-mounts")
    flags+=("--disable-metrics")
    local_nonpersistent_flags+=("--disable-metrics")
    flags+=("--disable-optimizations")
    local_nonpersistent_flags+=("--disable-optimizations")
    flags+=("--disk-size=")
    two_word_flags+=("--disk-size")
    local_nonpersistent_flags+=("--disk-size")
    local_nonpersistent_flags+=("--disk-size=")
    flags+=("--dns-domain=")
    two_word_flags+=("--dns-domain")
    local_nonpersistent_flags+=("--dns-domain")
    local_nonpersistent_flags+=("--dns-domain=")
    flags+=("--dns-proxy")
    local_nonpersistent_flags+=("--dns-proxy")
    flags+=("--docker-env=")
    two_word_flags+=("--docker-env")
    local_nonpersistent_flags+=("--docker-env")
    local_nonpersistent_flags+=("--docker-env=")
    flags+=("--docker-opt=")
    two_word_flags+=("--docker-opt")
    local_nonpersistent_flags+=("--docker-opt")
    local_nonpersistent_flags+=("--docker-opt=")
    flags+=("--download-only")
    local_nonpersistent_flags+=("--download-only")
    flags+=("--driver=")
    two_word_flags+=("--driver")
    local_nonpersistent_flags+=("--driver")
    local_nonpersistent_flags+=("--driver=")
    flags+=("--dry-run")
    local_nonpersistent_flags+=("--dry-run")
    flags+=("--embed-certs")
    local_nonpersistent_flags+=("--embed-certs")
    flags+=("--enable-default-cni")
    local_nonpersistent_flags+=("--enable-default-cni")
    flags+=("--extra-config=")
    two_word_flags+=("--extra-config")
    local_nonpersistent_flags+=("--extra-config")
    local_nonpersistent_flags+=("--extra-config=")
    flags+=("--extra-disks=")
    two_word_flags+=("--extra-disks")
    local_nonpersistent_flags+=("--extra-disks")
    local_nonpersistent_flags+=("--extra-disks=")
    flags+=("--feature-gates=")
    two_word_flags+=("--feature-gates")
    local_nonpersistent_flags+=("--feature-gates")
    local_nonpersistent_flags+=("--feature-gates=")
    flags+=("--force")
    local_nonpersistent_flags+=("--force")
    flags+=("--force-systemd")
    local_nonpersistent_flags+=("--force-systemd")
    flags+=("--host-dns-resolver")
    local_nonpersistent_flags+=("--host-dns-resolver")
    flags+=("--host-only-cidr=")
    two_word_flags+=("--host-only-cidr")
    local_nonpersistent_flags+=("--host-only-cidr")
    local_nonpersistent_flags+=("--host-only-cidr=")
    flags+=("--host-only-nic-type=")
    two_word_flags+=("--host-only-nic-type")
    local_nonpersistent_flags+=("--host-only-nic-type")
    local_nonpersistent_flags+=("--host-only-nic-type=")
    flags+=("--hyperkit-vpnkit-sock=")
    two_word_flags+=("--hyperkit-vpnkit-sock")
    local_nonpersistent_flags+=("--hyperkit-vpnkit-sock")
    local_nonpersistent_flags+=("--hyperkit-vpnkit-sock=")
    flags+=("--hyperkit-vsock-ports=")
    two_word_flags+=("--hyperkit-vsock-ports")
    local_nonpersistent_flags+=("--hyperkit-vsock-ports")
    local_nonpersistent_flags+=("--hyperkit-vsock-ports=")
    flags+=("--hyperv-external-adapter=")
    two_word_flags+=("--hyperv-external-adapter")
    local_nonpersistent_flags+=("--hyperv-external-adapter")
    local_nonpersistent_flags+=("--hyperv-external-adapter=")
    flags+=("--hyperv-use-external-switch")
    local_nonpersistent_flags+=("--hyperv-use-external-switch")
    flags+=("--hyperv-virtual-switch=")
    two_word_flags+=("--hyperv-virtual-switch")
    local_nonpersistent_flags+=("--hyperv-virtual-switch")
    local_nonpersistent_flags+=("--hyperv-virtual-switch=")
    flags+=("--image-mirror-country=")
    two_word_flags+=("--image-mirror-country")
    local_nonpersistent_flags+=("--image-mirror-country")
    local_nonpersistent_flags+=("--image-mirror-country=")
    flags+=("--image-repository=")
    two_word_flags+=("--image-repository")
    local_nonpersistent_flags+=("--image-repository")
    local_nonpersistent_flags+=("--image-repository=")
    flags+=("--insecure-registry=")
    two_word_flags+=("--insecure-registry")
    local_nonpersistent_flags+=("--insecure-registry")
    local_nonpersistent_flags+=("--insecure-registry=")
    flags+=("--install-addons")
    local_nonpersistent_flags+=("--install-addons")
    flags+=("--interactive")
    local_nonpersistent_flags+=("--interactive")
    flags+=("--iso-url=")
    two_word_flags+=("--iso-url")
    local_nonpersistent_flags+=("--iso-url")
    local_nonpersistent_flags+=("--iso-url=")
    flags+=("--keep-context")
    local_nonpersistent_flags+=("--keep-context")
    flags+=("--kubernetes-version=")
    two_word_flags+=("--kubernetes-version")
    local_nonpersistent_flags+=("--kubernetes-version")
    local_nonpersistent_flags+=("--kubernetes-version=")
    flags+=("--kvm-gpu")
    local_nonpersistent_flags+=("--kvm-gpu")
    flags+=("--kvm-hidden")
    local_nonpersistent_flags+=("--kvm-hidden")
    flags+=("--kvm-network=")
    two_word_flags+=("--kvm-network")
    local_nonpersistent_flags+=("--kvm-network")
    local_nonpersistent_flags+=("--kvm-network=")
    flags+=("--kvm-numa-count=")
    two_word_flags+=("--kvm-numa-count")
    local_nonpersistent_flags+=("--kvm-numa-count")
    local_nonpersistent_flags+=("--kvm-numa-count=")
    flags+=("--kvm-qemu-uri=")
    two_word_flags+=("--kvm-qemu-uri")
    local_nonpersistent_flags+=("--kvm-qemu-uri")
    local_nonpersistent_flags+=("--kvm-qemu-uri=")
    flags+=("--listen-address=")
    two_word_flags+=("--listen-address")
    local_nonpersistent_flags+=("--listen-address")
    local_nonpersistent_flags+=("--listen-address=")
    flags+=("--memory=")
    two_word_flags+=("--memory")
    local_nonpersistent_flags+=("--memory")
    local_nonpersistent_flags+=("--memory=")
    flags+=("--mount")
    local_nonpersistent_flags+=("--mount")
    flags+=("--mount-9p-version=")
    two_word_flags+=("--mount-9p-version")
    local_nonpersistent_flags+=("--mount-9p-version")
    local_nonpersistent_flags+=("--mount-9p-version=")
    flags+=("--mount-gid=")
    two_word_flags+=("--mount-gid")
    local_nonpersistent_flags+=("--mount-gid")
    local_nonpersistent_flags+=("--mount-gid=")
    flags+=("--mount-ip=")
    two_word_flags+=("--mount-ip")
    local_nonpersistent_flags+=("--mount-ip")
    local_nonpersistent_flags+=("--mount-ip=")
    flags+=("--mount-msize=")
    two_word_flags+=("--mount-msize")
    local_nonpersistent_flags+=("--mount-msize")
    local_nonpersistent_flags+=("--mount-msize=")
    flags+=("--mount-options=")
    two_word_flags+=("--mount-options")
    local_nonpersistent_flags+=("--mount-options")
    local_nonpersistent_flags+=("--mount-options=")
    flags+=("--mount-port=")
    two_word_flags+=("--mount-port")
    local_nonpersistent_flags+=("--mount-port")
    local_nonpersistent_flags+=("--mount-port=")
    flags+=("--mount-string=")
    two_word_flags+=("--mount-string")
    local_nonpersistent_flags+=("--mount-string")
    local_nonpersistent_flags+=("--mount-string=")
    flags+=("--mount-type=")
    two_word_flags+=("--mount-type")
    local_nonpersistent_flags+=("--mount-type")
    local_nonpersistent_flags+=("--mount-type=")
    flags+=("--mount-uid=")
    two_word_flags+=("--mount-uid")
    local_nonpersistent_flags+=("--mount-uid")
    local_nonpersistent_flags+=("--mount-uid=")
    flags+=("--namespace=")
    two_word_flags+=("--namespace")
    local_nonpersistent_flags+=("--namespace")
    local_nonpersistent_flags+=("--namespace=")
    flags+=("--nat-nic-type=")
    two_word_flags+=("--nat-nic-type")
    local_nonpersistent_flags+=("--nat-nic-type")
    local_nonpersistent_flags+=("--nat-nic-type=")
    flags+=("--native-ssh")
    local_nonpersistent_flags+=("--native-ssh")
    flags+=("--network=")
    two_word_flags+=("--network")
    local_nonpersistent_flags+=("--network")
    local_nonpersistent_flags+=("--network=")
    flags+=("--network-plugin=")
    two_word_flags+=("--network-plugin")
    local_nonpersistent_flags+=("--network-plugin")
    local_nonpersistent_flags+=("--network-plugin=")
    flags+=("--nfs-share=")
    two_word_flags+=("--nfs-share")
    local_nonpersistent_flags+=("--nfs-share")
    local_nonpersistent_flags+=("--nfs-share=")
    flags+=("--nfs-shares-root=")
    two_word_flags+=("--nfs-shares-root")
    local_nonpersistent_flags+=("--nfs-shares-root")
    local_nonpersistent_flags+=("--nfs-shares-root=")
    flags+=("--no-kubernetes")
    local_nonpersistent_flags+=("--no-kubernetes")
    flags+=("--no-vtx-check")
    local_nonpersistent_flags+=("--no-vtx-check")
    flags+=("--nodes=")
    two_word_flags+=("--nodes")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--nodes")
    local_nonpersistent_flags+=("--nodes=")
    local_nonpersistent_flags+=("-n")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--ports=")
    two_word_flags+=("--ports")
    local_nonpersistent_flags+=("--ports")
    local_nonpersistent_flags+=("--ports=")
    flags+=("--preload")
    local_nonpersistent_flags+=("--preload")
    flags+=("--qemu-firmware-path=")
    two_word_flags+=("--qemu-firmware-path")
    local_nonpersistent_flags+=("--qemu-firmware-path")
    local_nonpersistent_flags+=("--qemu-firmware-path=")
    flags+=("--registry-mirror=")
    two_word_flags+=("--registry-mirror")
    local_nonpersistent_flags+=("--registry-mirror")
    local_nonpersistent_flags+=("--registry-mirror=")
    flags+=("--service-cluster-ip-range=")
    two_word_flags+=("--service-cluster-ip-range")
    local_nonpersistent_flags+=("--service-cluster-ip-range")
    local_nonpersistent_flags+=("--service-cluster-ip-range=")
    flags+=("--socket-vmnet-client-path=")
    two_word_flags+=("--socket-vmnet-client-path")
    local_nonpersistent_flags+=("--socket-vmnet-client-path")
    local_nonpersistent_flags+=("--socket-vmnet-client-path=")
    flags+=("--socket-vmnet-path=")
    two_word_flags+=("--socket-vmnet-path")
    local_nonpersistent_flags+=("--socket-vmnet-path")
    local_nonpersistent_flags+=("--socket-vmnet-path=")
    flags+=("--ssh-ip-address=")
    two_word_flags+=("--ssh-ip-address")
    local_nonpersistent_flags+=("--ssh-ip-address")
    local_nonpersistent_flags+=("--ssh-ip-address=")
    flags+=("--ssh-key=")
    two_word_flags+=("--ssh-key")
    local_nonpersistent_flags+=("--ssh-key")
    local_nonpersistent_flags+=("--ssh-key=")
    flags+=("--ssh-port=")
    two_word_flags+=("--ssh-port")
    local_nonpersistent_flags+=("--ssh-port")
    local_nonpersistent_flags+=("--ssh-port=")
    flags+=("--ssh-user=")
    two_word_flags+=("--ssh-user")
    local_nonpersistent_flags+=("--ssh-user")
    local_nonpersistent_flags+=("--ssh-user=")
    flags+=("--static-ip=")
    two_word_flags+=("--static-ip")
    local_nonpersistent_flags+=("--static-ip")
    local_nonpersistent_flags+=("--static-ip=")
    flags+=("--subnet=")
    two_word_flags+=("--subnet")
    local_nonpersistent_flags+=("--subnet")
    local_nonpersistent_flags+=("--subnet=")
    flags+=("--trace=")
    two_word_flags+=("--trace")
    local_nonpersistent_flags+=("--trace")
    local_nonpersistent_flags+=("--trace=")
    flags+=("--uuid=")
    two_word_flags+=("--uuid")
    local_nonpersistent_flags+=("--uuid")
    local_nonpersistent_flags+=("--uuid=")
    flags+=("--vm")
    local_nonpersistent_flags+=("--vm")
    flags+=("--vm-driver=")
    two_word_flags+=("--vm-driver")
    local_nonpersistent_flags+=("--vm-driver")
    local_nonpersistent_flags+=("--vm-driver=")
    flags+=("--wait=")
    two_word_flags+=("--wait")
    local_nonpersistent_flags+=("--wait")
    local_nonpersistent_flags+=("--wait=")
    flags+=("--wait-timeout=")
    two_word_flags+=("--wait-timeout")
    local_nonpersistent_flags+=("--wait-timeout")
    local_nonpersistent_flags+=("--wait-timeout=")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_status()
{
    last_command="minikube_status"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--format=")
    two_word_flags+=("--format")
    two_word_flags+=("-f")
    local_nonpersistent_flags+=("--format")
    local_nonpersistent_flags+=("--format=")
    local_nonpersistent_flags+=("-f")
    flags+=("--layout=")
    two_word_flags+=("--layout")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--layout")
    local_nonpersistent_flags+=("--layout=")
    local_nonpersistent_flags+=("-l")
    flags+=("--node=")
    two_word_flags+=("--node")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--node")
    local_nonpersistent_flags+=("--node=")
    local_nonpersistent_flags+=("-n")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--watch")
    flags+=("-w")
    local_nonpersistent_flags+=("--watch")
    local_nonpersistent_flags+=("-w")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_stop()
{
    last_command="minikube_stop"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all")
    local_nonpersistent_flags+=("--all")
    flags+=("--cancel-scheduled")
    local_nonpersistent_flags+=("--cancel-scheduled")
    flags+=("--keep-context-active")
    local_nonpersistent_flags+=("--keep-context-active")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--schedule=")
    two_word_flags+=("--schedule")
    local_nonpersistent_flags+=("--schedule")
    local_nonpersistent_flags+=("--schedule=")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_tunnel()
{
    last_command="minikube_tunnel"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--bind-address=")
    two_word_flags+=("--bind-address")
    local_nonpersistent_flags+=("--bind-address")
    local_nonpersistent_flags+=("--bind-address=")
    flags+=("--cleanup")
    flags+=("-c")
    local_nonpersistent_flags+=("--cleanup")
    local_nonpersistent_flags+=("-c")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_unpause()
{
    last_command="minikube_unpause"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--all-namespaces")
    flags+=("-A")
    local_nonpersistent_flags+=("--all-namespaces")
    local_nonpersistent_flags+=("-A")
    flags+=("--namespaces=")
    two_word_flags+=("--namespaces")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--namespaces")
    local_nonpersistent_flags+=("--namespaces=")
    local_nonpersistent_flags+=("-n")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_update-check()
{
    last_command="minikube_update-check"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_update-context()
{
    last_command="minikube_update-context"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_version()
{
    last_command="minikube_version"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--components")
    local_nonpersistent_flags+=("--components")
    flags+=("--output=")
    two_word_flags+=("--output")
    two_word_flags+=("-o")
    local_nonpersistent_flags+=("--output")
    local_nonpersistent_flags+=("--output=")
    local_nonpersistent_flags+=("-o")
    flags+=("--short")
    local_nonpersistent_flags+=("--short")
    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_minikube_root_command()
{
    last_command="minikube"

    command_aliases=()

    commands=()
    commands+=("addons")
    commands+=("cache")
    commands+=("completion")
    commands+=("config")
    commands+=("cp")
    commands+=("dashboard")
    commands+=("delete")
    commands+=("docker-env")
    commands+=("help")
    commands+=("image")
    commands+=("ip")
    commands+=("kubectl")
    commands+=("license")
    commands+=("logs")
    commands+=("mount")
    commands+=("node")
    commands+=("options")
    commands+=("pause")
    commands+=("podman-env")
    commands+=("profile")
    commands+=("service")
    commands+=("ssh")
    commands+=("ssh-host")
    commands+=("ssh-key")
    commands+=("start")
    commands+=("status")
    commands+=("stop")
    commands+=("tunnel")
    commands+=("unpause")
    if [[ -z "${BASH_VERSION:-}" || "${BASH_VERSINFO[0]:-}" -gt 3 ]]; then
        command_aliases+=("resume")
        aliashash["resume"]="unpause"
    fi
    commands+=("update-check")
    commands+=("update-context")
    commands+=("version")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--add_dir_header")
    flags+=("--alsologtostderr")
    flags+=("--bootstrapper=")
    two_word_flags+=("--bootstrapper")
    two_word_flags+=("-b")
    flags+=("--help")
    flags+=("-h")
    flags+=("--log_backtrace_at=")
    two_word_flags+=("--log_backtrace_at")
    flags+=("--log_dir=")
    two_word_flags+=("--log_dir")
    flags+=("--log_file=")
    two_word_flags+=("--log_file")
    flags+=("--log_file_max_size=")
    two_word_flags+=("--log_file_max_size")
    flags+=("--logtostderr")
    flags+=("--one_output")
    flags+=("--profile=")
    two_word_flags+=("--profile")
    two_word_flags+=("-p")
    flags+=("--rootless")
    flags+=("--skip-audit")
    flags+=("--skip_headers")
    flags+=("--skip_log_headers")
    flags+=("--stderrthreshold=")
    two_word_flags+=("--stderrthreshold")
    flags+=("--user=")
    two_word_flags+=("--user")
    flags+=("--v=")
    two_word_flags+=("--v")
    two_word_flags+=("-v")
    flags+=("--vmodule=")
    two_word_flags+=("--vmodule")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

__start_minikube()
{
    local cur prev words cword split
    declare -A flaghash 2>/dev/null || :
    declare -A aliashash 2>/dev/null || :
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -s || return
    else
        __minikube_init_completion -n "=" || return
    fi

    local c=0
    local flag_parsing_disabled=
    local flags=()
    local two_word_flags=()
    local local_nonpersistent_flags=()
    local flags_with_completion=()
    local flags_completion=()
    local commands=("minikube")
    local command_aliases=()
    local must_have_one_flag=()
    local must_have_one_noun=()
    local has_completion_function=""
    local last_command=""
    local nouns=()
    local noun_aliases=()

    __minikube_handle_word
}

if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -F __start_minikube minikube
else
    complete -o default -o nospace -F __start_minikube minikube
fi

# ex: ts=4 sw=4 et filetype=sh

BASH_COMPLETION_EOF
}
__minikube_bash_source <(__minikube_convert_bash_to_zsh)

#compdef helm

# zsh completion for helm                                 -*- shell-script -*-

__helm_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_helm()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace
    local -a completions

    __helm_debug "\n========= starting completion logic =========="
    __helm_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __helm_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __helm_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., helm -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __helm_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __helm_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __helm_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __helm_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __helm_debug "No directive found.  Setting do default"
        directive=0
    fi

    __helm_debug "directive: ${directive}"
    __helm_debug "completions: ${out}"
    __helm_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __helm_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __helm_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __helm_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __helm_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __helm_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __helm_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __helm_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __helm_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __helm_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __helm_debug "Calling _describe"
        if eval _describe "completions" completions $flagPrefix $noSpace; then
            __helm_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __helm_debug "_describe did not find completions."
            __helm_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __helm_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __helm_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_helm" ]; then
    _helm
fi
compdef _helm helm


#compdef helmfile
compdef _helmfile helmfile

# zsh completion for helmfile                             -*- shell-script -*-

__helmfile_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_helmfile()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16
    local shellCompDirectiveKeepOrder=32

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace keepOrder
    local -a completions

    __helmfile_debug "\n========= starting completion logic =========="
    __helmfile_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __helmfile_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __helmfile_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., helmfile -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __helmfile_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __helmfile_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __helmfile_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __helmfile_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __helmfile_debug "No directive found.  Setting do default"
        directive=0
    fi

    __helmfile_debug "directive: ${directive}"
    __helmfile_debug "completions: ${out}"
    __helmfile_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __helmfile_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __helmfile_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __helmfile_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __helmfile_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __helmfile_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __helmfile_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveKeepOrder)) -ne 0 ]; then
        __helmfile_debug "Activating keep order."
        keepOrder="-V"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __helmfile_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __helmfile_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __helmfile_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __helmfile_debug "Calling _describe"
        if eval _describe $keepOrder "completions" completions $flagPrefix $noSpace; then
            __helmfile_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __helmfile_debug "_describe did not find completions."
            __helmfile_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __helmfile_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __helmfile_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_helmfile" ]; then
    _helmfile
fi
