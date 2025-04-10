if yes_or_no "Are you sure?" false
    set -l BRANCH_TO_DEL $(git branch --show-current)
    set -l DEFAULT_BRANCH $(git default-branch-name)

    set -l protected main master release staging develop

    if test $BRANCH_TO_DEL = $DEFAULT_BRANCH
        echo "can't abandon default branch"
        return
    end

    if contains $BRANCH_TO_DEL $protected
        echo "can't abandon protected branch"
        return
    end

    git checkout $DEFAULT_BRANCH; or return
    git pull; or return
    git branch -d "$BRANCH_TO_DEL"; or return
    git push origin -d "$BRANCH_TO_DEL"
end
