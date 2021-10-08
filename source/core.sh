#!/bin/bash

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
  add_meta $obj_backup_dir_name $(realpath $1)
}

# Add metadata to rbsh meta file
add_meta() {
  # $1 is backup file path
  # $2 is source absolute path

  echo "$1, $2" >> "$META_FILE_PATH"
}

# List all removed objects
list_objects() {
  cat $META_FILE_PATH
}

# Recover removed objects
recover_objects() {
  if [ -d "$1" || -f "$1" ]; then
    echo "haha"
  else
    echo "File or directory doesn't exist !"
    exit 1
  fi
}

# Show cli help
show_help() {
  rm --help
}
