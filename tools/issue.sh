#!/bin/bash

resultFile=compile.failed
issueFile=issue.log
bodyText="Automatic compilation failed

$(cat $issueFile 2>/dev/null)

You can view the details through the following link

$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID

[$(date +"%Y-%m-%d %H:%M %Z %A")]"

if [ -f $resultFile ]; then
    echo "Compilation failed"
    issueNumber=$(gh issue list --json number,title --jq 'first(.[] | select(.title == "ci: build failed")).number')

    if [ "$issueNumber" ]; then
        gh issue comment $issueNumber --body "$bodyText"
    else
        gh issue create --title "ci: build failed" --body "$bodyText"
    fi

    exit 1
else
    echo "Compilation successful"
fi
