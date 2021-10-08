#!/bin/bash

# Remove source objects (files, directories, etc.)
remove_objects() {
  # $1 is source object

  this_time=$(($(date +%s%N)/1000000))
  absolute_path=$(realpath $1)
  path_md5_hash=$(echo -n $absolute_path-$this_time | md5sum | awk '{print $1}')
  obj_backup_dir_path="$BACKUP_DIR_PATH/$path_md5_hash/"

  if [ -d $absolute_path ]; then
    absolute_path="$absolute_path/"
  fi

  mkdir "$obj_backup_dir_path" && \
  mv "$absolute_path" "$obj_backup_dir_path" && \
  add_meta $path_md5_hash $absolute_path
}

# Add metadata to rbsh meta file
add_meta() {
  # $1 is backup file path
  # $2 is source absolute path

  echo "$(date), $1, $2" >> "$META_FILE_PATH"
}

# List all removed objects
list_objects() {
  echo "Hash | Date | Path"

  if [[ $(wc -l < $META_FILE_PATH) != "0" ]]; then
    while IFS="," read -r r_date r_hash r_path; do
      if [[ ! -z "$r_path" && ! -z "$r_date" && ! -z "$r_hash" ]]; then
        echo "$r_hash | $r_date | $r_path" | xargs
      fi
    done < $META_FILE_PATH
  else
    echo "--- No data avalable ---"
  fi
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

# Remove object(s) permanently
clear_objects() {
  rm -rf $BACKUP_DIR_PATH/* && \
  echo -n > $META_FILE_PATH
}
