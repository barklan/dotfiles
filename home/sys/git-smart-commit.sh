#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

git smart-prep
git commit --status
