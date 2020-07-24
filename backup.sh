#!/bin/bash
# script for external backup of only the files i want

EXT="/Volumes/My Book for Mac" 
PIC="/Users/blastomussa/Pictures/Photos Library.photoslibrary/masters"
MUS="/Users/blastomussa/music/itunes/itunes media/music"
MEMO="/Users/blastomussa/Music/iTunes/iTunes Media/Voice Memos"
DESK="/Users/blastomussa/Desktop" 
BEAU="/Users/blastomussa/Documents/Beaurocracy"
SCHO="/Users/blastomussa/Documents/School"
VID="/Users/blastomussa/Documents/PowerOutage"
E_WRONG=85

# Usage function
usage(){
cat << EOF
   Usage: backup -option arg ...
     OPTIONS : 
       -p      Backup pictures
       -m      Backup Music
       -d      Backup Desktop/Misc
       -v      Backup Videos
       -h      Display this message
     REQUIRES: 
       - macOS
       - external hard drive
       - mounted @ "/Volumes/My Book for Mac"
       - change \$EXT to path in `basename $0` if necessary
EOF
}

# Pictures backup to External Drive
pics_back(){
    cd "${PIC}"
    # if there are too many must be done with a for loop over the cat of a 
    # filename containing all the images; rsync has a variable count limit
    rsync -vu `find ./ -name '*.JPG'` "$EXT/pics_backup"
    rsync -vu `find ./ -name '*.JPEG'` "$EXT/pics_backup"
    rsync -vu `find ./ -name '*.jpg'` "$EXT/pics_backup"
    rsync -vu `find ./ -name '*.jpeg'` "$EXT/pics_backup"
    rsync -vu `find ./ -name '*.MP4'` "$EXT/vids_backup"
    rsync -vu `find ./ -name '*.PNG'` "$EXT/pics_backup"
    rsync -vu `find ./ -name '*.png'` "$EXT/pics_backup"
    rsync -vu `find ./ -name '*.mov'` "$EXT/vids_backup"
    rsync -vu `find ./ -name '*.MOV'` "$EXT/vids_backup"
    rsync -vu `find ./ -name '*.mp4'` "$EXT/vids_backup"
}

# Music backup to External Drive 
mus_back(){
    cd ~
    rsync -vur "${MEMO}" "${EXT}"
    rsync -vur "${MUS}" "${EXT}"
}

# Desktop backup to External Drive
desk_back(){
    cd ~
    rsync -vur "${DESK}" "${EXT}" 
    rsync -vur "${BEAU}" "${EXT}/Desktop"
    rsync -vur "${SCHO}" "${EXT}/Desktop"
}

# Videos backup
vids_back(){
    cd ~
    rsync -vur "${VID}" "${EXT}"
}

# Check for null arguments
if [ $# -eq 0 ]; then
  echo "*** No arguments supplied ***"
  usage
  exit $E_WRONG
fi

# check if backup directory exists
if [ ! -d "${EXT}" ]
then
    echo "*** External drive not found ***"
    echo "- Must be mounted at /Volumes/My Book for Mac"
    exit 1
fi

# Flag Get Options
while getopts 'mpdvh' flag; do
  case "${flag}" in
    m) mus_back ;;
    p) pics_back ;;
    d) desk_back ;;
    v) vids_back ;;
    h) usage
       exit 0 ;;
  esac
done  

exit 0

