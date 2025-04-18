#!/bin/bash

# Script to replace "omnivore" with "ruminer" in file contents while preserving case
# Usage: ./update_file_contents.sh [path_to_monorepo] [file_extensions]

set -e

# Default path or use provided argument
REPO_PATH="${1:-/Users/tcai/Projects/Atmaware/Ruminer/monorepo}"
# Default file extensions to process
FILE_EXTENSIONS="${2:-js,jsx,ts,tsx,json,html,css,swift,kt,java,xml,plist,gradle,xcscheme}"

echo "Starting content replacement in: $REPO_PATH"
echo "Processing files with extensions: $FILE_EXTENSIONS"

# Create a log file
LOG_FILE="update_file_contents_$(date +%Y%m%d_%H%M%S).log"
echo "Logging to: $LOG_FILE"

# Convert extensions to a format suitable for find command
FIND_EXTENSIONS=$(echo "$FILE_EXTENSIONS" | sed 's/,/ -o -name \*/g')
FIND_EXTENSIONS="-name \*.$FIND_EXTENSIONS"

# Find files with the specified extensions
echo "Finding files to process..."
find "$REPO_PATH" -type f $FIND_EXTENSIONS | while read -r file; do
  echo "Processing: $file" | tee -a "$LOG_FILE"
  
  # Create a temporary file
  temp_file=$(mktemp)
  
  # Replace Omnivore -> Ruminer and omnivore -> ruminer
  sed -e 's/Omnivore/Ruminer/g' -e 's/omnivore/ruminer/g' "$file" > "$temp_file"
  
  # Check if any changes were made
  if ! cmp -s "$file" "$temp_file"; then
    echo "  Updated: $file" | tee -a "$LOG_FILE"
    mv "$temp_file" "$file"
  else
    echo "  No changes needed: $file" | tee -a "$LOG_FILE"
    rm "$temp_file"
  fi
done

echo "Content replacement completed. Check $LOG_FILE for details."
