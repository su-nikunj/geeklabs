#!/bin/bash

check_latest_commit() {
    # Use git diff-tree to compare the latest commit with its parent
    # -r: recurse into subdirectories
    # --no-commit-id: suppress the commit ID output
    # --name-status: show the status (A, M, D) and the file name
    git diff-tree -r --no-commit-id --name-status HEAD | while read -r status file; do
        # Check if file name has .container extension
        if [[ $file == *.container ]]; then
            filename_extension="${file##*/}"
            filename="${filename_extension%.*}"

            case $status in
                A)
                    echo "New service $filename"
                    systemctl daemon-reload
                    systemctl --user enable --now $filename
                    ;;
                M)
                    echo "Modified service $filename"
                    systemctl daemon-reload
                    systemctl --user restart $filename
                    ;;
                D)
                    echo "Deleted service $filename"
                    systemctl --user disable --now $filename
                    systemctl --user daemon-reload
            esac
        fi
    done
}

# Fetch the latest updates from the remote
git fetch -q

# Check if the local branch is behind the remote branch
UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    echo "Up to date."
elif [ $LOCAL = $BASE ]; then
    echo "Changes detected. Pulling now..."
    git merge --ff-only
    check_latest_commit
elif [ $REMOTE = $BASE ]; then
    echo "Local is ahead of remote. No pull needed."
else
    echo "Branches have diverged. Manual intervention required."
fi
