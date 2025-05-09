#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

current=$(git branch --show-current)
cmd="git push $* origin $current && notify-send 'pushed $current'"
systemd-run --same-dir --collect --user bash -c "$cmd" &
