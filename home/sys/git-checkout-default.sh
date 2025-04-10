#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export BRANCH="$(git default-branch-name)"
git checkout "${BRANCH}"
git pull
