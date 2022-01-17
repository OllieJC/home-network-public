#!/usr/bin/env bash

# check if running as root (sudo)
if [ "$EUID" -ne 0 ]; then echo "Run as root" && exit 1; fi

# check if *not* running as root
if [ "$EUID" -eq 0 ]; then echo "Do not run as root" && exit 1; fi

# append forward slash to HOME if doesn't have it
if [[ "$HOME" =~ [^\/]$ ]]; then HOME="${HOME}/"; fi
CWD=$(pwd)


# do stuff


# Finish
echo "Finished."
cd "$CWD" || exit 1
