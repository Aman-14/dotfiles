#!/bin/zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export XDG_CONFIG_HOME="$HOME/.config"
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:/$HOME/bin
export PATH="/Users/aman/.codeium/windsurf/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH=$HOME/.local/bin:$PATH
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$HOME/scripts/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.mongo_tools/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# . "$HOME/.cargo/env"

# Zinit initialization
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# History settings for proper sync across tabs
setopt SHARE_HISTORY          # Share history across all sessions
setopt APPEND_HISTORY         # Append to history file, don't overwrite
setopt INC_APPEND_HISTORY     # Write to history file immediately, not when shell exits
setopt HIST_IGNORE_DUPS       # Don't record duplicate entries
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries from history
setopt HIST_FIND_NO_DUPS      # Don't display duplicates when searching
setopt HIST_SAVE_NO_DUPS      # Don't save duplicates to history file
setopt HIST_VERIFY            # Show command with history expansion to user before running it
# History file settings
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# Load plugins with Zinit
# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# zinit ice as"command" from"gh-r" \
#           atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
#           atpull"%atclone" src"init.zsh"
# zinit light starship/starship

# Git plugin
zinit snippet OMZP::git
# direnv plugin (keeps hook on precmd/chpwd; logs are silenced below)
# zinit snippet OMZP::direnv
# Vi-mode plugin
zinit light jeffreytse/zsh-vi-mode
# Syntax highlighting (load this last)
zinit light zsh-users/zsh-syntax-highlighting
# History substring search (load after syntax highlighting)
zinit light zsh-users/zsh-history-substring-search
# Auto suggestions
zinit light zsh-users/zsh-autosuggestions
# Auto complete
# zinit light marlonrichert/zsh-autocomplete

# custom bindings for history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# completions
autoload -Uz compinit
compinit
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# Preferred editor
export EDITOR='nvim'
export ASTA_DIR="/Users/aman/.asta"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias vi='nvim'
alias genKey="openssl rand -base64 24"
alias now='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias c="clear"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
alias git_main_branch='echo production'
alias redis-cli='docker exec -it redis-stack redis-cli'
alias hs='homeserver'
alias p='pnpm'
alias otterscan="pm2 serve ~/workspace/misc/otterscan/dist/ --spa --port 3010"
alias ls='eza --icons=auto'
alias l="eza --icons=auto --long -a"
alias ht='npx hardhat'

function f () {
    source ~/scripts/search.sh
}

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

function rbhash () {
  ruby -rjson -rpp -e '
    input = STDIN.tty? ? `pbpaste` : STDIN.read

    i = input.index("{")
    j = input.rindex("}")
    abort("No {..} hash found in input") unless i && j && j > i

    h = input[i..j]

    obj = eval(h) # only for trusted logs
    puts JSON.pretty_generate(obj)
  ' | jq
}



# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd --log-level quiet --shell zsh)"

# fzf config ---------------------------------------------------------
# Base fd command that excludes common directories
export FZF_EXCLUDE="--exclude .git --exclude node_modules --exclude Library --exclude Applications --exclude Downloads --exclude Documents --exclude Pictures --exclude Music --exclude Movies --exclude '*.app'"
# CTRL-T - Paste the selected files and directories onto the command-line
export FZF_CTRL_T_COMMAND="fd --type f --type d --follow $FZF_EXCLUDE"
# ALT-C - CD into the selected directory
export FZF_ALT_C_COMMAND="fd --type d --follow $FZF_EXCLUDE"
# Functions used for shell completion
_fzf_compgen_path() {
  sh -c "fd --follow $FZF_EXCLUDE . '$1'"
}
_fzf_compgen_dir() {
  sh -c "fd --type d --follow $FZF_EXCLUDE . '$1'"
}
# Default options
export FZF_DEFAULT_OPTS="
  --height 40% 
  --layout=reverse 
  --border 
  --info=inline
  --preview='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
  --preview-window='right:60%'
  --bind='ctrl-/:toggle-preview'
"
# Options specific to CTRL-T
export FZF_CTRL_T_OPTS="
  --preview='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
  --preview-window='right:60%'
"
# Options specific to ALT-C
export FZF_ALT_C_OPTS="
  --preview 'tree -C {} | head -200'
  --preview-window='right:60%'
"
source <(fzf --zsh)
# fzf config ---------------------------------------------------------

unset CONDA_PREFIX

# pnpm
export PNPM_HOME="/Users/aman/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/aman/.bun/_bun" ] && source "/Users/aman/.bun/_bun"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
