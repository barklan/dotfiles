#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

joined=$(echo "$*" | tr '\n' ' ')
current=$(git branch --show-current)
cmd="git push ${joined} origin $current && notify-send 'pushed $current'"
echo "$cmd"
systemd-run --same-dir --collect --user bash -c "$cmd" &
