#!/bin/bash

# TMux folder search popup action.
# 1) Runs ~/scripts/search.nu to pick a directory via fzf.
# 2) Searches only the "workspace" session for a pane already in that directory
#    (or any subdirectory of it).
# 3) If found, switches to that window/pane.
# 4) If not found, creates a new window in "workspace" at the selected directory.

set -euo pipefail

SEARCH_SCRIPT="$HOME/scripts/search.nu"
NU_BIN="$(command -v nu || true)"

if [[ -z "$NU_BIN" ]]; then
  tmux display-message "nu is not installed"
  exit 1
fi

if [[ ! -f "$SEARCH_SCRIPT" ]]; then
  tmux display-message "search.nu not found at $SEARCH_SCRIPT"
  exit 1
fi

selected_dir="$(TMUX_SEARCH_MODE=print "$NU_BIN" "$SEARCH_SCRIPT" | tr -d '\r')"

if [[ -z "$selected_dir" || ! -d "$selected_dir" ]]; then
  exit 0
fi

# Normalize selected path so matching works even if shell/tmux reports physical paths.
selected_dir="${selected_dir%/}"
selected_real="$(cd "$selected_dir" && pwd -P)"

target_session="workspace"

if ! tmux has-session -t "$target_session" 2>/dev/null; then
  tmux new-session -d -s "$target_session" -c "$selected_dir"
  tmux switch-client -t "$target_session"
  exit 0
fi

pane_target="$(
  tmux list-panes -a -F '#{session_name}|#{window_index}|#{pane_index}|#{pane_current_path}' \
    | awk -F '|' -v session="$target_session" -v target="$selected_dir" -v target_real="$selected_real" '
      $1 == session && ($4 == target || index($4, target "/") == 1 || $4 == target_real || index($4, target_real "/") == 1) {
        print $2 "\t" $3
        exit
      }
    '
)"

if [[ -n "$pane_target" ]]; then
  window_index="${pane_target%%$'\t'*}"
  pane_index="${pane_target##*$'\t'}"
  tmux switch-client -t "${target_session}:${window_index}"
  tmux select-pane -t "${target_session}:${window_index}.${pane_index}"
  exit 0
fi

window_name="$(basename "$selected_dir")"
new_window_index="$(
  tmux new-window -P -F '#{window_index}' -t "$target_session" -c "$selected_dir" -n "$window_name"
)"
tmux switch-client -t "${target_session}:${new_window_index}"
