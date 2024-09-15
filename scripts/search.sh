#!/bin/bash

directories=("workspace/work-lsc@2" "workspace/work-protostar@1" "workspace/personal@1" "workspace/misc@1" ".config@1")
all=""

for directory in "${directories[@]}"; do
	search_dir=$(echo "$directory" | cut -d '@' -f 1)
	depth=$(echo "$directory" | cut -d '@' -f 2)
	all+=$(fd . "$HOME/$search_dir" --type d --exact-depth "$depth")
	all+="\n"
done

res=$(echo "$all" | fzf)
# check if something is selected and open nvim

if [ -n "$res" ]; then
	cd "$res" || exit
	nvim
fi
