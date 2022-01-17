#!/usr/bin/env bash

if [ "$EUID" -eq 0 ]; then echo "Do not run as root" && exit 1; fi

# append forward slash to HOME if doesn't have it
if [[ "$HOME" =~ [^\/]$ ]]; then HOME="${HOME}/"; fi
CWD=$(pwd)

HNPD="/home/$USER/github/home-network"
if test -d "$HNPD"; then
  cd "$HNPD" || exit 1
  git pull
else
  if [ -d "/home/$USER/github" ]; then
    echo "github directory already exists."
  else
    mkdir "/home/$USER/github"
  fi
  cd "/home/$USER/github/" || exit 1
  git clone git@github.com:OllieJC/home-network.git
fi

# Finish
echo "Finished."
cd "$CWD" || exit 1
