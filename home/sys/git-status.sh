#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

git status --show-stash
echo '-----------------------------'

printf "Last commit: %s\n" "$(git log -1 --pretty=format:'%h %s [%an, %ar]')"

default=$(git default-branch-name)
current=$(git branch --show-current)

default_ab=$(git rev-list --left-right --count @..."$default")
default_a=$(echo "$default_ab" | awk '{print $1}')
default_b=$(echo "$default_ab" | awk '{print $2}')

git branch --merged "$default" | rg --fixed-strings -q "$current" || error_code=$?
error_code="${error_code:-0}"
if [ "${error_code}" -eq 0 ]; then
    merged_msg="$current is merged into $default"
elif [ "${error_code}" -eq 1 ]; then
    merged_msg="$current is not merged into $default"
else
    merged_msg="Could not check if branch is merged, exit code $error_code"
fi

printf "\e[1m%s\e[0m: %s ahead, %s behind (%s)\n" "$default" "$default_a" "$default_b" "$merged_msg"

push_ab=$(git rev-list --left-right --count '@...@{push}')
push_a=$(echo "$push_ab" | awk '{print $1}')
push_b=$(echo "$push_ab" | awk '{print $2}')

printf "\e[1m%s\e[0m: %s ahead, %s behind\n" "remote" "$push_a" "$push_b"
