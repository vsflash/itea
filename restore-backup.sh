#!/bin/bash

set -e

#---------------------VALIDATION_PARAMETRS---------------------------------------------
if [[ ! $1 ]];
then
   echo "Not enough parameters"
   exit 1
fi

if [[ ! $1 =~ ^[0-3][0-9]-[0-1][0-9]-[0-9]{4}$ ]];
then
  echo "Date must be in format <d-m-y>"
  exit 1
fi

BACKUPS_ROOT=backups/$1
if [[ ! -d $BACKUPS_ROOT ]];
then
   echo "Directory $BACKUPS_ROOT doesn't exist!"
   exit 1
fi
#---------------------CHECK_FILES_IN_DIRECTORY----------------------------------------
if [[ ! -f "$BACKUPS_ROOT"/dump.sql.gz ]];
then
   echo "File dump.sql.gz doesn't exist in $BACKUPS_ROOT directory!"
   exit 1
fi

if [[ ! -f "$BACKUPS_ROOT"/uploads.zip ]];
then
   echo "File uploads.zip doesn't exist in $BACKUPS_ROOT directory!"
   exit 1
fi

#---------------------RESTORE_DUMP----------------------------------------------------
echo "Restore backup..."
gunzip -dk "$BACKUPS_ROOT"/dump.sql.gz
mv "$BACKUPS_ROOT"/dump.sql ./

#---------------------RESTORE_BACKED--------------------------------------------------
BACKEND_DIRECTORY=backend/web/uploads
if [[ ! -d $BACKEND_DIRECTORY ]];
then
   mkdir -p "$BACKEND_DIRECTORY"
fi

echo "Restore upload..."
unzip -qj "$BACKUPS_ROOT"/uploads.zip -d "$BACKEND_DIRECTORY"
echo "All done!"
