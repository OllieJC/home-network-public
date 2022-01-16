#!/usr/bin/env bash

GPK="~/.ssh/id_ed25519.github"

if [ -f "$GPK" ]; then
  echo "GitHub private key exists, continuing..."
else
  echo "GitHub private key doesn't exist, install at '$GPK'"
fi

ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

git config --global user.email "github@olliejc.uk"
git config --global user.name "OllieJC"

echo """Host github
    Hostname github.com
    IdentityFile $GPK
    IdentitiesOnly yes""" > ~/.ssh/config
