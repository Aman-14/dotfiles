#!/bin/bash
# Unified tmux session picker with cached repo discovery.
# Sources: live tmux sessions + cached sesh configs + cached ~/workspace repos.
# After selection, refreshes caches in the background for the next run.
# A newly-created repo shows up one invocation later.

set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/tmux-sesh-picker"
REPOS_CACHE="$CACHE_DIR/repos"
CONFIGS_CACHE="$CACHE_DIR/configs"
# Override via env: TMUX_SESH_PICKER_TTL=<seconds>. Default: 2 hours.
TTL_SECONDS="${TMUX_SESH_PICKER_TTL:-7200}"

FORCE_REFRESH=0
MODE=pick
case "${1:-}" in
  --refresh | -r) FORCE_REFRESH=1 ;;
  --list) MODE=list ;;
esac

mkdir -p "$CACHE_DIR"

assemble_list() {
  local current_session
  current_session="$(tmux display -p '#S' 2>/dev/null || true)"
  {
    # Sort tmux sessions by last-attached time (most recent first).
    # session_last_attached is 0 for never-attached sessions, so they sink.
    tmux list-sessions -F '#{session_last_attached} #S' 2>/dev/null \
      | sort -rn -k1,1 \
      | cut -d' ' -f2- \
      | grep -vFx "$current_session" || true
    cat "$CONFIGS_CACHE" 2>/dev/null
    cat "$REPOS_CACHE" 2>/dev/null
  } | awk '!seen[$0]++'
}

# --list prints the picker entries and exits (used by fzf's reload binding).
if [[ "$MODE" == list ]]; then
  assemble_list
  exit 0
fi

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

needs_refresh() {
  local file="$1"
  (( FORCE_REFRESH )) && return 0
  [[ ! -s "$file" ]] && return 0
  local mtime
  mtime=$(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null || echo 0)
  (( $(date +%s) - mtime > TTL_SECONDS ))
}

build_repos() {
  # Exclude heavyweight dirs up front; fd still has to walk them otherwise
  # because -I ignores .gitignore. Explicit excludes are ~7x faster.
  fd -LHId 4 --glob '.git' --format '{//}' "$HOME/workspace" \
    --exclude node_modules \
    --exclude dist \
    --exclude build \
    --exclude .cache \
    --exclude target \
    --exclude .next \
    --exclude vendor \
    2>/dev/null | sort -u
}

build_configs() {
  sesh list -c 2>/dev/null || true
}

atomic_write() {
  local dest="$1"
  local tmp="${dest}.$$.tmp"
  cat >"$tmp" && mv "$tmp" "$dest"
}

entry_exists() {
  assemble_list | grep -Fx -- "$1" >/dev/null
}

# Synchronous rebuild if missing or past TTL.
needs_refresh "$REPOS_CACHE" && build_repos | atomic_write "$REPOS_CACHE"
needs_refresh "$CONFIGS_CACHE" && build_configs | atomic_write "$CONFIGS_CACHE"

fzf_output="$(
  assemble_list |
    fzf --print-query --no-sort --ansi \
      --border-label ' sesh ' \
      --prompt '⚡  ' \
      --header '  ^d kill session  ·  tmux sessions, sesh configs, repos' \
      --bind 'enter:accept-or-print-query' \
      --bind "ctrl-d:execute-silent(tmux kill-session -t {} 2>/dev/null || true)+reload($SCRIPT_PATH --list)" \
      --preview 'sesh preview {} 2>/dev/null || eza -T -L2 --color=always {} 2>/dev/null || echo {}' \
      --preview-window 'right,50%'
)"
query="$(printf '%s\n' "$fzf_output" | sed -n '1p')"
choice="$(printf '%s\n' "$fzf_output" | sed -n '2p')"
selected=""
if [[ -n "$choice" ]] && { entry_exists "$choice" || [[ "$choice" = /* && -d "$choice" ]]; }; then
  selected="$choice"
elif [[ "$query" = /* && -d "$query" ]]; then
  selected="$query"
fi

# Fire-and-forget background refresh so the next run reflects any new repos.
( build_repos | atomic_write "$REPOS_CACHE"; build_configs | atomic_write "$CONFIGS_CACHE" ) \
  </dev/null >/dev/null 2>&1 &
disown 2>/dev/null || true

[[ -z "$selected" ]] && exit 0
exec sesh connect "$selected"
