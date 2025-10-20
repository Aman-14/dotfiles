#!/bin/bash

SSH_SESSION="ssh-servers"
SSH_CONFIG="$HOME/.ssh/config"
LAST_HOST_FILE="$HOME/.cache/tmux-ssh-last-host"

# Colors optimized for popup
export FZF_DEFAULT_OPTS="
    --height=100%
    --layout=reverse
    --border=rounded
    --margin=1,2
    --info=inline
    --prompt='🔍 SSH Host: '
    --pointer='▶'
    --marker='✓'
    --header='Select SSH host (ESC to cancel, Enter to connect)'
    --header-first

"

# Function to get all SSH hosts from config
get_ssh_hosts() {
	local hosts=$(grep "^Host " "$SSH_CONFIG" | grep -v "\*" | awk '{print $2}' | sort)
	local last_host=""

	# Read last used host from file
	if [ -f "$LAST_HOST_FILE" ]; then
		last_host=$(cat "$LAST_HOST_FILE" 2>/dev/null)
	fi

	# If we have a last host, put it first, then the rest
	if [ -n "$last_host" ] && echo "$hosts" | grep -q "^$last_host$"; then
		echo "$last_host"
		echo "$hosts" | grep -v "^$last_host$"
	else
		echo "$hosts"
	fi
}

# Function to create session if it doesn't exist
create_session() {
	if ! tmux has-session -t "$SSH_SESSION" 2>/dev/null; then
		tmux new-session -d -s "$SSH_SESSION" -c "$HOME"
	fi
}

# Function to check if window exists and get its index
get_window_info() {
	local host="$1"
	tmux list-windows -t "$SSH_SESSION" -F "#{window_index}:#{window_name}" 2>/dev/null | grep ":$host$" | cut -d: -f1
}

# Function to connect to host
connect_to_host() {
	local host="$1"

	create_session

	# Save this host as the last used
	mkdir -p "$(dirname "$LAST_HOST_FILE")"
	echo "$host" >"$LAST_HOST_FILE"

	local window_index=$(get_window_info "$host")

	if [ -n "$window_index" ]; then
		# Window exists, switch to it
		tmux switch-client -t "$SSH_SESSION:$window_index"
	else
		# Create new window
		tmux new-window -t "$SSH_SESSION" -n "$host"
		tmux send-keys -t "$SSH_SESSION:$host" "ssh $host" C-m

		# Get the new window index and switch to it
		window_index=$(get_window_info "$host")
		tmux switch-client -t "$SSH_SESSION:$window_index"
	fi
}



# Main selection function
select_and_connect() {
	local hosts=$(get_ssh_hosts)

	if [ -z "$hosts" ]; then
		echo "❌ No SSH hosts found in $SSH_CONFIG"
		read -p "Press any key to close..." -n 1
		exit 1
	fi

	local selected_host=$(echo "$hosts" | fzf \
		--bind 'enter:accept,esc:cancel,ctrl-c:cancel')

	if [ -n "$selected_host" ]; then
		connect_to_host "$selected_host"
	fi
}

# Handle different modes
case "${1:-}" in
--session-status)
	if tmux has-session -t "$SSH_SESSION" 2>/dev/null; then
		echo "🟢 SSH session '$SSH_SESSION' is active"
		echo
		echo "Active connections:"
		tmux list-windows -t "$SSH_SESSION" -F "  #{window_index}: #{window_name} #{?window_active,(current),}"

		if [ "$(tmux list-windows -t "$SSH_SESSION" | wc -l)" -eq 0 ]; then
			echo "  No active SSH connections"
		fi
	else
		echo "🔴 SSH session '$SSH_SESSION' is not running"
	fi
	;;
*)
	select_and_connect
	;;
esac
