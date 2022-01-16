#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then echo "Run as root" && exit 1; fi

CWD=$(pwd)

IS_LOCAL=-1
FILE="/home/$SUDO_USER/github/home-network-public/readme.md"
if test -f "$FILE"; then
  IS_LOCAL=1
else
  IS_LOCAL=0
fi

# User

NEW_USER="ollie"
NEW_USERS_HOME="/home/$NEW_USER/"

if grep -q "^$NEW_USER:" /etc/passwd; then
  echo "User '$NEW_USER' already exists"
else
  echo "Adding '$NEW_USER'..."
  useradd -s /bin/bash -d $NEW_USERS_HOME -m -G sudo "$NEW_USER"
fi

# User's groups

checkAddGroup () {
  echo "Checking if $NEW_USER is in $1..."
  if grep -q "^$1:.*[\:,]$NEW_USER" /etc/group; then
    echo "Yes, $NEW_USER is in $1."
  else
    echo "No, added $NEW_USER to $1."
    usermod -a -G "$1" "$NEW_USER"
  fi
}

checkAddGroup "adm"
checkAddGroup "sudo"

# SSH keys

checkAddKeys () {
  echo "Check if $NEW_USER has key '$1'..."

  if [ $IS_LOCAL -eq 1 ]; then
    KEYURL="/home/$SUDO_USER/github/home-network-public/ssh/$1.pub"
    KEYCONTENT=$(cat "$KEYURL")
  else
    KEYURL="https://raw.githubusercontent.com/OllieJC/home-network-public/main/ssh/$1.pub"
    KEYCONTENT=$(curl "$KEYURL")
  fi

  SSHDIR="/home/$NEW_USER/.ssh/"
  if [ -d "$SSHDIR" ]; then
    echo "$SSHDIR already exists."
  else
    su "$SUDO_USER" -c "mkdir '$SSHDIR'"
  fi

  if grep -q "$KEYCONTENT" "${NEW_USERS_HOME}.ssh/authorized_keys"; then
    echo "Yes, $NEW_USER has $1 already."
  else
    echo "No, adding $1 to $NEW_USER."
    echo "$KEYCONTENT" >> "${NEW_USERS_HOME}.ssh/authorized_keys"
  fi
}

checkAddKeys "home-network-infra-ed25519"

# Finish
echo "Finished configuring '$NEW_USER'."
cd "$CWD" || exit 1
