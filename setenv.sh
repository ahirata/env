#!/bin/bash

cd $(dirname "$0")

function resolve_destination() {
  no_leading_dot=${1#.}
  echo ${no_leading_dot%.symlink}
}

function create_links() {
  OPTIND=1
  with_sudo=''
  prefix=''
  while getopts ':sp:' flag; do
    case "${flag}" in
      s) with_sudo=sudo ;;
      p) prefix="${OPTARG}" ;;
      \?) echo "Invalid option -${OPTARG}. Aborting."; exit 1 ;;
    esac
  done


  echo "[Creating symlinks to ${prefix}]"
  find . -name "*.symlink" -print0 | while read -d $'\0' f; do
    source_file=$(realpath "$f")
    link_name="$prefix$(resolve_destination "$f")"
    link_dir="$(dirname "$link_name")"

    if [[ ! -d "$link_dir" ]]; then
      $with_sudo mkdir -p "$link_dir"
    fi
    if [[ ! -d "$link_name" ]]; then
        $with_sudo ln -sTf "$source_file" "$link_name"
    fi
  done
  echo "[Done]"
}

cd etc
create_links -s -p /etc
cd ..

cd dotfiles
create_links -p $HOME
cd ../
