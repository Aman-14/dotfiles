#!/bin/zsh

# Core shell behavior and shared environment defaults.
setopt promptsubst

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export EDITOR="nvim"
export ASTA_DIR="$HOME/.asta"
export BUN_INSTALL="$HOME/.bun"
export CARAPACE_BRIDGES="zsh"
export FZF_EXCLUDE="--exclude .git --exclude node_modules --exclude Library --exclude Applications --exclude Downloads --exclude Documents --exclude Pictures --exclude Music --exclude Movies --exclude '*.app'"

# Build PATH once, keep your preferred bins early, and dedupe duplicates.
typeset -U path PATH
path=(
  /opt/homebrew/bin
  /opt/homebrew/opt/mysql-client/bin
  /opt/homebrew/opt/libpq/bin
  /opt/homebrew/opt/ruby/bin
  /usr/local/bin
  "$HOME/bin"
  "$HOME/.local/bin"
  "$HOME/scripts/bin"
  "$HOME/.mongo_tools/bin"
  "$HOME/.codeium/windsurf/bin"
  "$HOME/.opencode/bin"
  "$BUN_INSTALL/bin"
  "$path[@]"
)

# Clean up malformed entries like //Users/aman/bin left by older PATH exports.
integer path_index
for ((path_index = 1; path_index <= $#path; ++path_index)); do
  while [[ ${path[path_index]} == //* ]]; do
    path[path_index]=${path[path_index]#/}
  done
done
typeset -U path PATH

# Persist and share history across shells without keeping duplicate commands.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Interactive plugins. Skip these in non-TTY shells to keep scripts lightweight.
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
if [[ -t 0 && -t 1 && -r "${ZINIT_HOME}/zinit.zsh" ]]; then
  source "${ZINIT_HOME}/zinit.zsh"
  zinit light jeffreytse/zsh-vi-mode
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-history-substring-search
  zinit light zsh-users/zsh-autosuggestions
  if (( $+functions[history-substring-search-up] )); then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
  fi
fi

# Completion system plus a cached compdump for faster startup.
autoload -Uz compinit
ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
mkdir -p "$ZSH_CACHE_DIR"
ZSH_COMPDUMP="${ZSH_CACHE_DIR}/zcompdump-${ZSH_VERSION}"
if [[ -s "$ZSH_COMPDUMP" ]]; then
  compinit -d "$ZSH_COMPDUMP" -C
else
  compinit -d "$ZSH_COMPDUMP"
fi
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

# Carapace adds generated completions; cache its init script instead of regenerating it.
if command -v carapace >/dev/null 2>&1; then
  CARAPACE_INIT_CACHE="${XDG_CACHE_HOME}/carapace-init.zsh"
  if [[ ! -s "$CARAPACE_INIT_CACHE" || "$CARAPACE_INIT_CACHE" -ot "$(command -v carapace)" ]]; then
    CARAPACE_TMP="${CARAPACE_INIT_CACHE}.tmp.$$"
    carapace _carapace >|"$CARAPACE_TMP" && mv "$CARAPACE_TMP" "$CARAPACE_INIT_CACHE"
    rm -f "$CARAPACE_TMP"
  fi
  source "$CARAPACE_INIT_CACHE"
fi

# Prompt setup.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Day-to-day command shortcuts.
alias vi="nvim"
alias genKey="openssl rand -base64 24"
alias now='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias c="clear"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
alias git_main_branch="echo production"
alias redis-cli="docker exec -it redis-stack redis-cli"
alias hs="homeserver"
alias p="pnpm"
alias otterscan="pm2 serve ~/workspace/misc/otterscan/dist/ --spa --port 3010"
alias ht="npx hardhat"

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons=auto"
  alias l="eza --icons=auto --long -a"
fi

# Personal helpers for repeated tasks.
f() {
  source "$HOME/scripts/search.sh"
}

secret() {
  aws secretsmanager get-secret-value --secret-id "$1" | jq '.SecretString | fromjson'
}

rbhash() {
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

# FZF configuration: file discovery, previews, and completion helpers.
export FZF_CTRL_T_COMMAND="fd --type f --type d --follow $FZF_EXCLUDE"
export FZF_ALT_C_COMMAND="fd --type d --follow $FZF_EXCLUDE"

_fzf_compgen_path() {
  sh -c "fd --follow $FZF_EXCLUDE . '$1'"
}

_fzf_compgen_dir() {
  sh -c "fd --type d --follow $FZF_EXCLUDE . '$1'"
}

export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --info=inline
  --preview='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
  --preview-window='right:60%'
  --bind='ctrl-/:toggle-preview'
"

export FZF_CTRL_T_OPTS="
  --preview='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
  --preview-window='right:60%'
"

export FZF_ALT_C_OPTS="
  --preview 'tree -C {} | head -200'
  --preview-window='right:60%'
"

# Cache fzf's shell integration so interactive startups avoid re-running `fzf --zsh`.
if [[ -t 0 && -t 1 ]] && command -v fzf >/dev/null 2>&1; then
  FZF_INIT_CACHE="${XDG_CACHE_HOME}/fzf-init.zsh"
  if [[ ! -s "$FZF_INIT_CACHE" || "$FZF_INIT_CACHE" -ot "$(command -v fzf)" ]]; then
    FZF_INIT_TMP="${FZF_INIT_CACHE}.tmp.$$"
    fzf --zsh >|"$FZF_INIT_TMP" && mv "$FZF_INIT_TMP" "$FZF_INIT_CACHE"
    rm -f "$FZF_INIT_TMP"
  fi
  source "$FZF_INIT_CACHE"
fi

# Tool-specific shell integrations.
[[ -r "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

if command -v wt >/dev/null 2>&1; then
  eval "$(wt config shell init zsh)"
fi

[[ -r "$HOME/workspace/personal/ai-exec/shell/x.zsh" ]] && source "$HOME/workspace/personal/ai-exec/shell/x.zsh"

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Drop temporary cache variables from the interactive environment.
unset ZSH_CACHE_DIR ZSH_COMPDUMP CARAPACE_INIT_CACHE CARAPACE_TMP FZF_INIT_CACHE FZF_INIT_TMP
