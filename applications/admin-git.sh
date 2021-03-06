#!/usr/bin/env bash

if [ "$EUID" -eq 0 ]; then echo "Do not run as root" && exit 1; fi

if [[ "$HOME" =~ [^\/]$ ]]; then HOME="${HOME}/"; fi
CWD=$(pwd)


GPK="${HOME}.ssh/id_ed25519.github"
if [ -f "$GPK" ]; then
  echo "GitHub private key exists, continuing..."
  chmod 400 "$GPK"
else
  echo "GitHub private key doesn't exist, install at '$GPK'"
  exit 1
fi

GHNP="${HOME}github/home-network-public"
if [ -d "$GHNP" ]; then
  echo "GitHub repo 'home-network-public' exists, continuing..."
else
  echo "GitHub repo '~/github/home-network-public' doesn't exist"
  exit 1
fi

ssh-keyscan -t rsa github.com >> "${HOME}.ssh/known_hosts"

git config --global user.email "github@olliejc.uk"
git config --global user.name "OllieJC"

echo "Host github.com
    PreferredAuthentications publickey
    Hostname github.com
    IdentityFile $GPK
    IdentitiesOnly yes" > "${HOME}.ssh/config"

cd "$GHNP" || exit 1
git remote set-url origin git@github.com:OllieJC/home-network-public.git
git pull

GHN="${HOME}github/home-network"
if [ -d "$GHN" ]; then
  echo "GitHub repo 'home-network' exists, continuing..."
  cd "$GHN" || exit 1
  git pull
else
  echo "GitHub repo '~/github/home-network' doesn't exist, cloning"
  cd "${HOME}github"
  git clone git@github.com:OllieJC/home-network.git
fi

# Finish
echo "Finished."
cd "$CWD" || exit 1
