#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then echo "Run as root" && exit 1; fi

if [[ "$HOME" =~ [^\/]$ ]]; then HOME="${HOME}/"; fi
CWD=$(pwd)

APT_MIRROR="https://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu"

if command -v "apt" > /dev/null; then
  echo "apt available, continuing..."

  apt install -y apt-transport-https

  # backup the sources.list
  cp /etc/apt/sources.list /etc/apt/sources.list.backup

  # replace the current sources with the APT_MIRROR
  sed --in-place --regexp-extended "s https?://(.+?)ubuntu\.com/ubuntu $APT_MIRROR g" /etc/apt/sources.list

  # check "apt update"
  apt update
else
  echo "No apt, quiting."
  exit 1
fi

# Finish
echo "Finished."
cd "$CWD" || exit 1
