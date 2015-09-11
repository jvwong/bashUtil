#!/bin/bash

# This script does personal backups to a rsync backup server. You will end up
# with a 7 day rotating incremental backup. The incrementals will go
# into subdirectories named after the day of the week, and the current
# full backup goes into a directory called "current"
# tridge@linuxcare.com

# directory to backup
declare -a SOURCE_DIRS=("/home/jeffrey/Sync" "/home/jeffrey/Projects")

# excludes file - this contains a wildcard pattern per line of files to exclude
EXCLUDES=""

# destination directory
DESTINATION_DIR="/media/jeffrey/a5f84890-74b9-4989-bec9-f18252a1d14d2"

LOG_DIR="/home/jeffrey/rsync_backup"
LOG_FILENAME="rsync_backup.log"

		
########################################################################
# create the log diretory file
if [ ! -d "$LOG_DIR" ]; then
	mkdir -p "$LOG_DIR"
fi

# delete the log file if it exists
LOG_PATH="$LOG_DIR"/"$LOG_FILENAME"
if [ -e "$LOG_PATH" ]; then
	rm "$LOG_PATH"
fi

# Create the backup directory
BACKUP_DIR=`date +%A`
BACKUP_PATH="$DESTINATION_DIR"/"$BACKUP_DIR"
if [ ! -d "$BACKUP_PATH" ]; then
	mkdir -p "$BACKUP_PATH"
fi

OPTS="--force --ignore-errors --delete-excluded --exclude-from=$EXCLUDES --delete -av"

export PATH=$PATH:/bin:/usr/bin:/usr/local/bin

# now the actual transfer
for SOURCE_DIR in ${SOURCE_DIRS[@]}
do
	#echo ${SOURCE_DIR}
	rsync ${OPTS} ${SOURCE_DIR} ${BACKUP_PATH} >> ${LOG_PATH} 2>&1
done

