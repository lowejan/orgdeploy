#!/bin/bash

# Fail if variables are unset
set -eu -o pipefail

echo 'Check for configuration file'
if [ -f "./publish.el" ]; then
    echo "Org publish configuration file found."
elif [ -f "./config.el" ]; then
    echo "Org publish configuration file found."
else
    echo "No valid Org publish configuration file found. Stopping." && exit 1
fi

cd ${GITHUB_WORKSPACE}

echo 'Clone remote repository'
git clone https://github.com/${REMOTE} ${DEST}

echo 'Clean site'
if [ -d "${DEST}" ]; then
    rm -rf ${DEST}/*
fi

echo 'Build site'
emacs --batch --no-init-file --load publish.el --funcall org-publish-all

echo 'Publish to remote repository'
COMMIT_MESSAGE=${INPUT_COMMIT_MESSAGE}
[ -z $COMMIT_MESSAGE ] && COMMIT_MESSAGE="Deploy with ${GITHUB_WORKFLOW}"

cd ${DEST}
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
#git remote set-url origin https://${TOKEN}@github.com/${REMOTE}
git add .
git commit -am "$COMMIT_MESSAGE"

CONTEXT=${INPUT_BRANCH-master}
[ -z $CONTEXT ] && CONTEXT='master'

git push -f -q https://x-access-token:${TOKEN}@github.com/${REMOTE} $CONTEXT
