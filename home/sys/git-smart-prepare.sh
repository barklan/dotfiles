#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

git notify-behind

CURRENT_BRANCH=$(git branch --show-current)
# DEFAULT_BRANCH=$(git default-branch-name)

if [[ "$DISTRIB_ID" != 'EndeavourOS' ]]; then
    if [[ "$CURRENT_BRANCH" =~ ^(release|master|develop|main)$ ]]; then
        notify-send -a 'git' "can't commit to protected branch: $CURRENT_BRANCH"
        exit 111
    fi
fi

if (($(git status -s | wc -l) < 1)); then
    notify-send -a 'git' "nothing to commit"
    exit 111
elif (($(git diff --cached | wc -l) <= 1)); then
    git add --all
    # notify-send -a 'git' "staging all changes"
else
    if (($(git staged-files-with-unstaged-changes | wc -l) >= 1)); then
        notify-send -a 'git' "staged files with unstaged changes!" "$(git staged-files-with-unstaged-changes)"
    fi
fi
