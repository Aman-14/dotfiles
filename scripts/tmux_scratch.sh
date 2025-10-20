#!/bin/bash

# TMux Workspace Scratch Session Toggle
# ------------------------------------
# Workspace-specific scratch session toggle.
# - If in workspace_scratch -> switch to workspace
# - If in workspace -> toggle to workspace_scratch with window/directory preservation
# - If in any other session -> switch to workspace

# Get current session name
CURRENT_SESSION=$(tmux display-message -p '#S')

# Check if we're in workspace_scratch - switch back to workspace
if [[ "$CURRENT_SESSION" == "workspace_scratch" ]]; then
    tmux switch-client -t "workspace"
    exit 0
fi

# Check if we're in workspace - create/switch to workspace_scratch
if [[ "$CURRENT_SESSION" == "workspace" ]]; then
    SCRATCH_SESSION="workspace_scratch"
    
    # Get current window index and path
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
    exit 0
fi

# We're in some other session - switch to workspace
if tmux has-session -t "workspace" 2>/dev/null; then
    tmux switch-client -t "workspace"
else
    # Create workspace session if it doesn't exist
    tmux new-session -d -s "workspace"
    tmux switch-client -t "workspace"
fi
