#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then echo "Run as root" && exit 1; fi

if [[ "$HOME" =~ [^\/]$ ]]; then HOME="${HOME}/"; fi
CWD=$(pwd)

if command -v "apt" > /dev/null; then
  echo "apt available, continuing..."
else
  echo "No apt, quiting."
  exit 1
fi

apt update

apt install -y shellcheck git wget

# Finish
echo "Finished."
cd "$CWD" || exit 1
