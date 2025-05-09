#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

systemd-run -E CURRENT_BRANCH="$(git branch --show-current)" --same-dir --collect --user bash -c 'git push '"$*"' origin ${CURRENT_BRANCH} && notify-send "pushed ${CURRENT_BRANCH}"' &
