#!/bin/bash

# Script to check for changes in the upstream repository
# This script can be used locally for testing

UPSTREAM_REPO="damongolding/immich-kiosk"
UPSTREAM_BRANCH="main"
STATE_FILE=".last-commit"

echo "Checking for changes in $UPSTREAM_REPO/$UPSTREAM_BRANCH..."

# Get the latest commit SHA from upstream
LATEST_COMMIT=$(curl -s -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$UPSTREAM_REPO/commits/$UPSTREAM_BRANCH" | \
    jq -r '.sha')

if [ "$LATEST_COMMIT" = "null" ] || [ -z "$LATEST_COMMIT" ]; then
    echo "Error: Could not fetch latest commit from upstream repository"
    exit 1
fi

echo "Latest upstream commit: $LATEST_COMMIT"

# Check if we have a previous commit stored
if [ -f "$STATE_FILE" ]; then
    LAST_COMMIT=$(cat "$STATE_FILE")
    echo "Last known commit: $LAST_COMMIT"
    
    if [ "$LATEST_COMMIT" = "$LAST_COMMIT" ]; then
        echo "✅ No changes detected"
        exit 0
    else
        echo "🔄 Changes detected!"
        echo "Previous: $LAST_COMMIT"
        echo "Latest:   $LATEST_COMMIT"
    fi
else
    echo "🆕 First run - no previous commit found"
fi

# Store the latest commit
echo "$LATEST_COMMIT" > "$STATE_FILE"
echo "✅ Updated tracked commit to $LATEST_COMMIT"

# Get commit details
COMMIT_DETAILS=$(curl -s -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$UPSTREAM_REPO/commits/$LATEST_COMMIT")

COMMIT_MESSAGE=$(echo "$COMMIT_DETAILS" | jq -r '.commit.message')
COMMIT_AUTHOR=$(echo "$COMMIT_DETAILS" | jq -r '.commit.author.name')
COMMIT_DATE=$(echo "$COMMIT_DETAILS" | jq -r '.commit.author.date')

echo ""
echo "📝 Commit Details:"
echo "   Author: $COMMIT_AUTHOR"
echo "   Date:   $COMMIT_DATE"
echo "   Message: $COMMIT_MESSAGE"

exit 0