#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="$SCRIPT_DIR/files"
TARGET_DIR=$HOME

# Ensure the files directory exists
if [ ! -d "$FILES_DIR" ]; then
  echo "Error: The 'files' directory does not exist."
  exit 1
fi

echo "Create links"
# Loop through all files in the files directory
shopt -s dotglob
find "$FILES_DIR" -type f | while read -r file; do
  if [ -f "$file" ]; then
    RELATIVE_PATH="${file#$FILES_DIR/}"
    DIR=$TARGET_DIR/$(dirname $RELATIVE_PATH)
    #echo "file: $file -- relative path: $RELATIVE_PATH -- target: $DIR"
    [[ ! -d $DIR ]] && mkdir -p $DIR
    ln -s -f "$file" "$TARGET_DIR/$RELATIVE_PATH"
    echo "Created symlink for: $RELATIVE_PATH"
  fi
done

echo "All symlinks created successfully."

