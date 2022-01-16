#!/usr/bin/env bash

# check if running as root (sudo)
if [ "$EUID" -ne 0 ]
  then echo "Run as root"
  exit
fi

CWD=$(pwd)


# do stuff


# Finish
echo "Finished."
cd "$CWD" || exit 1
