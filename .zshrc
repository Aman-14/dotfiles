#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export IS_MACOS=true

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_LS_COLORS="true"

# Add wisely, as too many plugins slow down shell startup.
plugins=(git web-search vi-mode zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Preferred editor
export EDITOR='nvim'
export DISABLE_AUTO_TITLE='true'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.gem/ruby/2.6.0/bin:$PATH

alias vi='nvim'

alias genKey="openssl rand -base64 24"
alias now='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias c="clear"
alias tsnode="ts-node"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
alias git_main_branch='echo production'
alias redis-cli='docker exec -it redis-stack redis-cli'
alias hs='homeserver'
alias p='pnpm'
alias otterscan="pm2 serve ~/workspace/misc/otterscan/dist/ --spa --port 3010"

# if not macos add pbcopy alias to xclip
if ! $IS_MACOS; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

function f () {
    source ~/scripts/search.sh
}

# history | sed 's/^[[:space:]]*[0-9]*//' | sort | uniq | fzf

function secret () {
    aws secretsmanager get-secret-value --secret-id "$1" | jq '.SecretString | fromjson'
}

function stopwatch () {
    start=$(date +%s)
    while true; do
        now=$(date +%s)
        elapsed=$((now - start))
        hours=$((elapsed / 3600))
        minutes=$(( (elapsed / 60) % 60))
        seconds=$((elapsed % 60))
        printf '%02d:%02d:%02d\r' $hours $minutes $seconds
        sleep 1
    done
}

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$HOME/scripts/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.mongo_tools/bin:$PATH"

# bun completions
[ -s "/Users/aman/.bun/_bun" ] && source "/Users/aman/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/aman/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/aman/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/aman/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/aman/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd --log-level quiet --shell zsh)"

# setup golang PATH
export PATH=$PATH:/usr/local/go/bin
source <(fzf --zsh)
. "$HOME/.cargo/env"

source ~/powerlevel10k/powerlevel10k.zsh-theme

