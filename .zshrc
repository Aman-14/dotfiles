#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export CONDA_SETUP=false
export PYENV_SETUP=false
export IS_MACOS=false

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_LS_COLORS="true"

# Add wisely, as too many plugins slow down shell startup.
plugins=(git web-search vi-mode)

if $IS_MACOS; then
    plugins+=(zsh-autosuggestions zsh-syntax-highlighting)
fi

source $ZSH/oh-my-zsh.sh

# Preferred editor
export EDITOR='nvim'
export DISABLE_AUTO_TITLE='true'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


if $PYENV_SETUP; then
    # pyenv conf
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

export PATH=/Users/aman/.local/bin:$PATH
export PATH=/Users/aman/.gem/ruby/2.6.0/bin:$PATH

alias vim='nvim'
alias vi='nvim'

alias genKey="openssl rand -base64 24"
alias now='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias c="clear"
alias tsnode="ts-node"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
alias git_main_branch='echo production'
alias redis-cli='docker exec -it redis redis-cli'

function f () {
    source ~/scripts/search.sh
}

# history | sed 's/^[[:space:]]*[0-9]*//' | sort | uniq | fzf

function secret () {
    aws secretsmanager get-secret-value --secret-id "$1" | jq '.SecretString | fromjson'
}

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform


export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

# bun completions
[ -s "/Users/aman/.bun/_bun" ] && source "/Users/aman/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!

if $CONDA_SETUP; then
    # code to execute if condition is true
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
fi

# <<< conda initialize <<<

source ~/powerlevel10k/powerlevel10k.zsh-theme
