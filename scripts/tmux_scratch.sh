#!/bin/bash

# TMux Scratch Session Toggle
# --------------------------
# Toggles between main session and a scratch session ({session}_scratch).
# Maintains window indexes and directories between sessions.
# Creates scratch windows only if needed, preserving current path.

# Get current session name
CURRENT_SESSION=$(tmux display-message -p '#S')

# Check if we're already in a scratch session
if [[ "$CURRENT_SESSION" == *"_scratch" ]]; then
    # Get original session name by removing _scratch suffix
    ORIGINAL_SESSION=${CURRENT_SESSION%_scratch}
    # Switch back to original session
    tmux switch-client -t "$ORIGINAL_SESSION"
    exit 0
fi

SCRATCH_SESSION="${CURRENT_SESSION}_scratch"

# Get current window index
CURRENT_WINDOW_INDEX=$(tmux display-message -p '#I')
CURRENT_PATH=$(tmux display-message -p '#{pane_current_path}')

# Check if scratch session exists
if ! tmux has-session -t "$SCRATCH_SESSION" 2>/dev/null; then
    # Create new scratch session
    tmux new-session -d -s "$SCRATCH_SESSION" -c "$CURRENT_PATH"
fi

# Check if window with same index exists in scratch session
if tmux list-windows -t "$SCRATCH_SESSION" | grep -q "^$CURRENT_WINDOW_INDEX:"; then
    # Window exists, check if we need to change directory
    SCRATCH_WINDOW_PATH=$(tmux display-message -t "$SCRATCH_SESSION:$CURRENT_WINDOW_INDEX" -p '#{pane_current_path}')
    if [ "$SCRATCH_WINDOW_PATH" != "$CURRENT_PATH" ]; then
        # Only change directory if it's different
        tmux send-keys -t "$SCRATCH_SESSION:$CURRENT_WINDOW_INDEX" "cd $CURRENT_PATH" C-m
    fi
else
    # Create new window with same index
    tmux new-window -t "$SCRATCH_SESSION:$CURRENT_WINDOW_INDEX" -c "$CURRENT_PATH"
fi

# Switch to scratch session and window
tmux switch-client -t "$SCRATCH_SESSION:$CURRENT_WINDOW_INDEX"
