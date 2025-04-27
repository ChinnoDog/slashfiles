#!/bin/bash
set -euo pipefail

# Configuration
VMNAME="personal"
REPODIR="~/repositories/slashfiles"
AGE_SECONDS=5   # How recent files must be to sync
SLEEP_SECONDS=$((AGE_SECONDS - 1))

echo "Starting dom0 <== $VMNAME live sync session at $(date)..."
echo "Polling every $SLEEP_SECONDS seconds..."

# Step 1: Always do a full pull on startup
echo "Initial full sync..."
qvm-run --pass-io "$VMNAME" "cd $REPODIR && tar -czf - \$(git ls-files --cached --others --exclude-standard
)" \
  | sudo tar -xzvf - -C /
echo "Initial sync complete."

# Step 2: Enter continuous sync loop
while true; do
    echo "Sync cycle started at $(date)..."

    # Calculate safe mmin window
    MINUTES=$(( (AGE_SECONDS + 59) / 60 ))  # Round up
    if [[ "$MINUTES" -eq 0 ]]; then
        MINUTES=1
    fi
    
    echo "Syncing recently modified files (modified within last $MINUTES minute(s))..."
    
    # Clean and simple remote command building
    REMOTE_CMD="$(cat <<EOF
    cd $REPODIR && \
    comm -12 \
      <(git ls-files --cached --others --exclude-standard | sort) \
      <(find . -type f -mmin -$MINUTES | sed 's|^\./||' | sort) \
    | tar -czf - --files-from=-
EOF
    )"
    
    # Run the remote command and unpack the tar stream
    qvm-run --pass-io "$VMNAME" "$REMOTE_CMD" \
      | sudo tar -xzvf - -C /
 
    # Handle deletions
    echo "Checking for deleted files..."
    deleted_files=$(qvm-run --pass-io "$VMNAME" "cd $REPODIR && git status --porcelain" | awk '/^ D/ {print $2}' || true)

    if [[ -n "$deleted_files" ]]; then
        echo "Deleting removed files..."
        while IFS= read -r file; do
            sudo rm -v "/$file" || true
        done <<< "$deleted_files"
    else
        echo "No files to delete."
    fi

    echo "Sync cycle completed at $(date). Sleeping for $SLEEP_SECONDS seconds..."
    sleep "$SLEEP_SECONDS"
done

