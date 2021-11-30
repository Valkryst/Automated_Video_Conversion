## Installation

To download this script and its dependencies, copy and paste the following commands into your bash terminal.

```bash
# Install Dependencies
sudo apt update
sudo apt install ffmpeg wget



# Download Script
sudo wget https://github.com/Valkryst/Automated_Video_Conversion/blob/main/convert.sh



# Modify the script's permissions to allow it to be run.
sudo chmod +x convert.sh
```

With the script downloaded, you must then perform these steps:

* Move the script into its own folder.
  
  * e.g. `/home/conversion/video`

* Edit the script and make the following changes:
  
  * Change `/home/conversion/video` in the command  `cd /home/conversion/video` to point to the folder in which you placed the script.
  
  * Change `ubuntu` in the command `chown -R ubuntu "$folder_path"` to your username.
  
  * Change `ubuntu` in the command `chgrp -R ubuntu "$folder_path"` to your username.

* Run the script to generate all necessary subfolders.

* Add a [cron](https://en.wikipedia.org/wiki/Cron) job to run the script at a set interval.
  
  * e.g. `0 * * * * /bin/bash /home/conversion/video/convert.sh > /home/conversion/video/convert.log`

## Usage

Place files and folders in the `todo` folder and they will be converted by the cron job. You'll know a file has been completed, if the original file has been moved to `completed/original_files`.

After verifying that the converted file is as you expect, you can delete the original file from `completed/original_files`.

## Important Notes

* Any folders containing the word `sample` are deleted, along with all files within those folders.

* Any files ending in `.nfo` or `.txt` are deleted.
