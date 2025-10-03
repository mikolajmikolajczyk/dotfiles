#!/bin/sh

name="$1"

if [ -z "$name" ]; then
  echo "Please provide a parameter. Possible values:"
  for d in ./distroboxes/*; do
    [ -d "$d" ] && echo "  $(basename "$d")"
  done
  exit 1
fi

mkdir -p "$HOME/.secretfiles/global"
mkdir -p "$HOME/.secretfiles/$name"

distrobox assemble create \
  --file "distroboxes/$name/distrobox.ini" \
  --replace
