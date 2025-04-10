#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export BRANCH="$(git default-branch-name)"
export CURRENT="$(git branch --show-current)"

if [ "${BRANCH}" == "${CURRENT}" ]; then
	# All personal repos are on main, don't notify
	if [ "${CURRENT}" == "main" ]; then
		exit 0
	fi
	notify-send "Committing to ${CURRENT}!"
	exit 0
fi

timeout 5 git fetch origin "${BRANCH}":"${BRANCH}"

retVal=$?
if [ $retVal -eq 124 ]; then
	notify-send "fuck"
fi

export LEFT_RIGHT=$(git rev-list --left-right --count "${BRANCH}"..."${CURRENT}")

export LEFT_RIGHT_ARR=($LEFT_RIGHT)
export BEHIND="${LEFT_RIGHT_ARR[0]}"

if [ "${BEHIND}" != "0" ]; then
	notify-send "${CURRENT} is behind ${BRANCH} by ${BEHIND} commits!"
fi
