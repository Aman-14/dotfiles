#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy UUID
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

uuidgen | tr '[:upper:]' '[:lower:]' | xargs echo -n | pbcopy
