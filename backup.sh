#!/bin/bash

# This checks if the number of arguments is correct
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1] Set variables for the target directory and destination directory
targetDirectory=$1
destinationDirectory=$2

# [TASK 2] Display the values of the command line arguments
echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"

# [TASK 3] Define the current timestamp
currentTS=$(date +%s)

# [TASK 4] Define the backup file name
backupFileName="backup-$currentTS.tar.gz"


# [TASK 5] Define the absolute path of the current directory
origAbsPath=$(pwd)


# [TASK 6] Define the absolute path of the destination directory
destDirAbsPath=$(realpath "$destinationDirectory")



# [TASK 7] Change to the target directory
cd "$targetDirectory"



# [TASK 8] Get yesterday's timestamp
yesterdayTS=$(date -d '24 hours ago' +%s)



# [TASK 9] Create the list of files to backup (files modified since yesterday)
declare -a toBackup
for file in $(find . -type f)
do
  # [TASK 10] Check if the file was modified within the last 24 hours
  if [[ $(date -r "$file" +%s) -gt $yesterdayTS ]]
  then
    # [TASK 11] Add the file to the backup list
    toBackup+=("$file")
  fi
done

# [TASK 12] Create the backup file (compress and archive)
tar -czf "$backupFileName" "${toBackup[@]}"

# [TASK 13] Move the backup file to the destination directory
mv "$backupFileName" "$destDirAbsPath"

echo "Backup completed successfully!"

