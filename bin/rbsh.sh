#!/bin/bash

BACKUP_DIR_NAME=".rbsh"
META_FILE_NAME=".rbsh_meta"
BACKUP_DIR_PATH="$HOME/$BACKUP_DIR_NAME"
META_FILE_PATH="$HOME/$META_FILE_NAME"

# Remove source objects (files, directories, etc.)
remove() {
  # $1 is source object

  this_time=$(($(date +%s%N)/1000000))
  obj_backup_dir_name="$(echo $this_time)_$(basename $1)"
  obj_backup_dir_path="$BACKUP_DIR_PATH/$obj_backup_dir_name/"
  source_obj=$1

  if [ -d $1 ]; then
    source_obj="$source_obj/"
  fi

  mkdir "$obj_backup_dir_path" && \
  mv "$source_obj" "$obj_backup_dir_path" && \
  add_meta $obj_backup_dir_name
}

clear() {}

add_meta() {
  echo "$1" >> "$META_FILE_PATH"
}

remove $1
