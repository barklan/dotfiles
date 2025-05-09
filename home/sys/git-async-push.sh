#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

systemd-run --same-dir --collect --user bash -c "CURRENT_BRANCH=$(git branch --show-current) git push $* origin ${CURRENT_BRANCH} && notify-send 'pushed ${CURRENT_BRANCH}'" &
