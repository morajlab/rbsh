#!/bin/bash

# Init constants
BACKUP_DIR_NAME=".rbsh"
META_FILE_NAME=".rbsh_meta"
BACKUP_DIR_PATH="$HOME/$BACKUP_DIR_NAME"
META_FILE_PATH="$HOME/$META_FILE_NAME"

# CLI options
HELP_OPTION_LONG="--help"
HELP_OPTION_SHORT="-h"
LIST_ARGUMENT="list"

# Load core functions
source ./source/core.sh

# Check options and arguments
while [ "$#" -gt 0 ]; do
  case "${1^^}" in
    "${LIST_ARGUMENT^^}")
      list_objects
      shift
    ;;
    "${HELP_OPTION_LONG^^}" | "${HELP_OPTION_SHORT^^}")
      show_help
      shift
    ;;
    *)
      shift
    ;;
  esac
done
