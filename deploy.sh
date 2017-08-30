#!/usr/bin/env bash

BRANCH="master"

# Are we on the right branch?
if [[ "$TRAVIS_BRANCH" != "$BRANCH" ]]; then
    echo "deploy disabled on branch different than master"
    exit 1
fi
# Is this not a Pull Request?
if [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then
    echo "deploy disabled on pull request"
    exit 1
fi
# Is there a tag ?
if [[ -z "$TRAVIS_TAG" ]]; then
    echo "deploy disabled if no tag provided"
    exit 1
fi

# deployment
echo "create deploy temp directory"
rm -Rf /tmp/better-world-quotes-widget
mkdir -p /tmp/better-world-quotes-widget

echo "copy all project files"
cp -R admin languages public *.php *.md /tmp/better-world-quotes-widget

# TODO minify the css and js files

echo "add index.php Silence is golden in each directory where there isn't an index.php"
echo "<?php // Silence is golden" > /tmp/index.php
find /tmp/better-world-quotes-widget -type d \! -exec test -e '{}/index.php' \; -exec cp /tmp/index.php {} \;

echo "zip the files"
zip -r /tmp/better-world-quotes-widget.zip /tmp/better-world-quotes-widget

echo "create checksum file"
sha1sum /tmp/better-world-quotes-widget.zip > /tmp/better-world-quotes-widget.zip.sha1