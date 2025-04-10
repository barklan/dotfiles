#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if git rev-parse --git-dir > /dev/null 2>&1; then
    timeout 10 git fm
fi
