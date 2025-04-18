#!/bin/bash

# Script to replace all filenames containing "omnivore" with "ruminer" while preserving case
# Usage: ./rename_omnivore_to_ruminer.sh [path_to_monorepo]

set -e

# Default path or use provided argument
REPO_PATH="${1:-/Users/tcai/Projects/Atmaware/Ruminer/monorepo}"
echo "Starting rename operation in: $REPO_PATH"

# Function to replace preserving case
replace_preserving_case() {
  local input=$1
  local capitalized="${input//Omnivore/Ruminer}"
  local result="${capitalized//omnivore/ruminer}"
  
  echo "$result"
}

# Create a log file
LOG_FILE="rename_omnivore_to_ruminer_$(date +%Y%m%d_%H%M%S).log"
echo "Logging to: $LOG_FILE"

# First, handle directories (from deepest to shallowest to avoid path issues)
echo "Processing directories..."
find "$REPO_PATH" -depth -type d -name "*[oO]mnivore*" | sort -r | while read -r dir; do
  new_dir=$(replace_preserving_case "$dir")
  echo "$dir -> $new_dir"
  if [ "$dir" != "$new_dir" ]; then
    parent_dir=$(dirname "$dir")
    base_name=$(basename "$dir")
    new_base_name=$(replace_preserving_case "$base_name")
    
    echo "Renaming directory: $dir -> $parent_dir/$new_base_name" | tee -a "$LOG_FILE"
    mv "$dir" "$parent_dir/$new_base_name"
  fi
done

# Then, handle files
echo "Processing files..."
find "$REPO_PATH" -type f -name "*[oO]mnivore*" | while read -r file; do
  new_file=$(replace_preserving_case "$file" "omnivore" "ruminer")
  if [ "$file" != "$new_file" ]; then
    parent_dir=$(dirname "$file")
    base_name=$(basename "$file")
    new_base_name=$(replace_preserving_case "$base_name" "omnivore" "ruminer")
    
    echo "Renaming file: $file -> $parent_dir/$new_base_name" | tee -a "$LOG_FILE"
    mv "$file" "$parent_dir/$new_base_name"
  fi
done

echo "Rename operation completed. Check $LOG_FILE for details."
echo "Note: You should also update file contents to replace 'omnivore' with 'ruminer'."
