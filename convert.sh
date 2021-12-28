#!/bin/bash

cd /home/conversion/video



# Prevent multiple instances of the script from being run.
lockfile="lockfile.tmp"
if [ -f "$lockfile" ]; then
        exit
fi
touch "$lockfile"



# Ensure Required Folders Exist
folder_todo="$(pwd)/todo"
folder_complete="$(pwd)/complete"
folder_original_files="$(pwd)/complete/original_files"

folders=( "$folder_todo" "$folder_complete" "$folder_original_files" )
for folder_path in "${folders[@]}"
do
        if [[ ! -d "$folder_path" ]]; then
                mkdir "$folder_path"
                echo "Created $folder_path"
        fi
done



# Delete Unnecessary Files & Folders
unnecessary_folder_patterns=( ".*[Ss][Aa][Mm][Pp][Ll][Ee].*" )
for pattern in "${unnecessary_folder_patterns[@]}"
do
        find "$folder_todo" -type d -regex "$pattern" | while read folder_path; do
                rm --recursive "$folder_path"
                echo "Deleted $folder_path"
        done
done

unnecessary_file_patterns=( ".*\.nfo" ".*\.txt" )
for pattern in "${unnecessary_file_patterns[@]}"
do
        find "$folder_todo" -type f -regex "$pattern" | while read file_path; do
                rm "$file_path"
                echo "Deleted $file_path"
        done
done



# Convert files.
extensions=( "avi" "divx" "flx" "m2ts" "m4v" "mkv" "mov" "mp4" "mpg" "ts" "webm" "wmv" )

for extension in "${extensions[@]}"
do
        find "$folder_todo" -regex ".*$extension" | while read file_path; do
                file_name="$(basename "$file_path")"
                output_folder="$folder_complete$(sed 's!'$folder_todo'!!g' <<< $(dirname "$file_path"))"

                if [[ ! -d "$output_folder" ]]; then # Ensure Output Folder Exists
                        mkdir "$output_folder"
                        echo "Created $output_folder"
                fi

                echo "Starting Conversion of $file_path"
                ffmpeg -i "$file_path" \
                        -codec:v libx265 \
                        -x265-params crf=10 \
                        -x265-params psy-rd=1 \
                        -c:a copy \
                        -c:s copy \
                        -map 0 \
                        -preset medium \
                        -threads 4 \
                        "$output_folder/$file_name.mkv" -y
                echo "Completed Conversion of $file_path"

                mv "$(dirname $file_path)" "$folder_original_files"
                echo "Moved \"$(dirname "$file_path")\" to \"$folder_original_files\""
        done
done



# Ensure the primary user is owner of all files/folders.
for folder_path in "${folders[@]}"
do
        chown -R ubuntu "$folder_path"
        chgrp -R ubuntu "$folder_path"
done



rm $lockfile
