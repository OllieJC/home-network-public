#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then echo "Run as root" && exit 1; fi

if [[ "$HOME" =~ [^\/]$ ]]; then HOME="${HOME}/"; fi
CWD=$(pwd)

if command -v "apt" > /dev/null; then
  echo "apt available, continuing..."

  if command -v "git" > /dev/null; then
    echo "git available already."
  else
    echo "Installing git..."
    apt update
    apt install -y git
  fi
else
  echo "No apt, quiting."
  exit 1
fi

HNPD="/home/$SUDO_USER/github/home-network-public"
if test -d "$HNPD"; then
  cd "$HNPD" || exit 1
  su "$SUDO_USER" -c 'git pull'
else
  if [ -d "/home/$SUDO_USER/github" ]; then
    echo "github directory already exists."
  else
    su "$SUDO_USER" -c "mkdir '/home/$SUDO_USER/github'"
  fi
  cd "/home/$SUDO_USER/github/" || exit 1
  su "$SUDO_USER" -c "git clone 'https://github.com/OllieJC/home-network-public.git'"
fi

# Finish
echo "Finished."
cd "$CWD" || exit 1
