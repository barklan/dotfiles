#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

git status --show-stash
echo

default=$(git default-branch-name)

git branch --merged "$default" | rg --fixed-strings -q "$(git branch --show-current)" || error_code=$?
if [ "${error_code}" -eq 0 ]; then
    echo "Branch is merged in $default"
elif [ "${error_code}" -eq 1 ]; then
    echo "Branch is not merged in $default"
else
    echo "Could not check if branch is merged, exit code $error_code"
fi

default_ab=$(git rev-list --left-right --count @..."$default")
default_a=$(echo "$default_ab" | awk '{print $1}')
default_b=$(echo "$default_ab" | awk '{print $2}')

printf "%s:\t%s ahead, %s behind\n" "$default" "$default_a" "$default_b"

push_ab=$(git rev-list --left-right --count '@...@{push}')
push_a=$(echo "$push_ab" | awk '{print $1}')
push_b=$(echo "$push_ab" | awk '{print $2}')

printf "%s:\t\t%s ahead, %s behind\n" "remote" "$push_a" "$push_b"

printf "Last commit: %s\n" "$(git log -1 --pretty=format:'%h %s [%an, %ar]')"
