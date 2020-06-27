#!/bin/sh

set -e

usage() {
  cat << EOF
usage: install.sh [-fh]

OPTIONS:
  -f  do it for real (write to $HOME). otherwise files are written to ./test
  -h  show this message
EOF
  exit 0
}

home_dir="test"

while getopts "fh" option; do
  case "$option" in
    f) home_dir="$HOME";;
    h) usage;;
    ?) usage;;
  esac
done

bin_dir="$home_dir/.local/bin"
utils_dir="$home_dir/utils"

symlink() {
  echo "  ${1#$PWD/} -> $2"
  ln -fs -- "$1" "$2"
}

echo installing bin
mkdir -p "$bin_dir"
for script in $(find bin -type f -executable) ; do
  symlink "$PWD/$script" "$bin_dir"
done

echo installing utils
mkdir -p "$utils_dir"
for script in utils/*; do
  symlink "$PWD/$script" "$utils_dir"
done

echo installing dotfiles
for df in $(find . -name '_*'); do
  if [ -d "$df" ]; then
    for f in $(find "$df" -type f); do
      dest="$home_dir/.${f#./_}"
      mkdir -p -m 700 "$(dirname "$dest")"
      chmod go-rwx "$f"
      symlink "$PWD/${f#./}" "$dest"
    done
  else
    dest="$home_dir/.${df#./_}"
    chmod go-rwx "$df"
    symlink "$PWD/${df#./}" "$dest"
  fi
done
