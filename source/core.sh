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

  mkdir -p "$obj_backup_dir_path" && \
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
  OPTION="--all"
  no_data=true

  echo "Hash | Date | Path"

  if [[ $(wc -l < $META_FILE_PATH) != "0" ]]; then
    while IFS="," read -r r_date r_hash r_path; do
      if [[ ! -z "$r_path" && ! -z "$r_date" && ! -z "$r_hash" ]]; then
        if [ "${1^^}" = "${OPTION^^}" ]; then
          no_data=false
          echo "$r_hash | $r_date | $r_path" | xargs
        else
          if [ "$1" = "$(echo -n $r_path | xargs)" -o "$1" = "$(echo -n $r_hash | xargs)" ]; then
            no_data=false
            echo "$r_hash | $r_date | $r_path" | xargs
          fi
        fi
      fi
    done < $META_FILE_PATH
  fi

  if [ "$no_data" = "true" ]; then
    echo "--- No data avalable ---"
  fi
}

# Remove object(s) permanently
clear_objects() {
  OPTION="--all"

  case "${1^^}" in
    "${OPTION^^}")
      rm -rf $BACKUP_DIR_PATH/* && \
      echo -n > $META_FILE_PATH
    ;;
    *)
      while IFS="," read -r r_date r_hash r_path; do
        if [[ ! -z "$r_path" && ! -z "$r_date" && ! -z "$r_hash" ]]; then
          if [ $1 = $r_path -o $1 = $r_hash ]; then
            rm -rf $BACKUP_DIR_PATH/$(echo -n $r_hash | xargs) && \
            sed -i "/$r_hash/d" $META_FILE_PATH
          fi
        fi
      done < $META_FILE_PATH
    ;;
  esac
}

# Recover removed objects
recover_objects() {
  OPTION="--all"
  occurrence_count=$(grep -c "$1" $META_FILE_PATH)

  if [ "$occurrence_count" = "0" ]; then
    echo "Object '$1' doesn't exist in recycle bin !" && exit 1
  fi

  if [ "$occurrence_count" -gt 1 ]; then
    echo "Which one do you want to recover ?(hash)" && echo && list_objects $1
    exit 1
  fi

  while IFS="," read -r r_date r_hash r_path; do
    if [[ ! -z "$r_path" && ! -z "$r_date" && ! -z "$r_hash" ]]; then
      if [ $1 = $r_path -o $1 = $r_hash ]; then
        mv $BACKUP_DIR_PATH/$(echo -n $r_hash | xargs)/$(basename $r_path)/* $r_path && \
        clear_objects $r_hash
      fi
    fi
  done < $META_FILE_PATH
}

# Show cli help
show_help() {
  rm --help
}
