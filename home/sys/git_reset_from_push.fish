set -l current $(git branch --show-current)
set -l current_push $(git rev-parse --abbrev-ref @{push})

if yes_or_no "Are you sure you want to reset $current from $current_push?" false
    git fetch origin && git reset --hard @{push}
end
