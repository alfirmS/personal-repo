#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <folder_path> <old_word> <new_word>"
  exit 1
fi

folder_path="$1"
old_word="$2"
new_word="$3"

# Check if the folder exists
if [ ! -d "$folder_path" ]; then
  echo "Folder '$folder_path' does not exist."
  exit 1
fi

# Replace the word in all files within the folder and its subfolders
find "$folder_path" -type f -exec sed -i "s/$old_word/$new_word/g" {} +

echo "Word '$old_word' replaced with '$new_word' in all files within the folder."

