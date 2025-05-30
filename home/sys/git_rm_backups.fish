git branch | rg '_backup_'

if yes_or_no "Are you sure you want to delete these?" false
    git branch | rg '_backup_' | xargs git branch -D
end
