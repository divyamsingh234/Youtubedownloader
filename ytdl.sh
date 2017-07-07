#!/bin/bash
#Edited by Divyam Singh
#created on 19feb 2017
File1New=video.mp4
File2New=audio.m4a

URL=$1
if [ -z $URL ]; then
  echo "Usage: ytdl.sh url"
  exit
fi

#Find what quality of videos are available
youtube-dl -F $URL
echo
echo -n "Quality for Video (default 137): "
read Qual1
echo -n "Quality for Audio (default 140): "
read Qual2

#Set values if user has just pressed Return without typing anything
if [ -z $Qual1 ]; then
  Qual1="137"
fi
if [ -z $Qual2 ]; then
  Qual2="140"
fi

#Set filenames from output of youtube-dl
File1=$(youtube-dl --get-filename -f $Qual1 $URL)
File2=$(youtube-dl --get-filename -f $Qual2 $URL)
echo $File1
echo $File2
Out=${File1:0:${#File1}-16}".mp4"
echo $Out

#Download Video file with First Quality Setting
youtube-dl -f $Qual1 $URL
if [[ ! -f $File1 ]]; then
  echo
  echo "Error video file not downloaded"
  exit
fi
mv "$File1" "$File1New"

#Download Audio file with Second Quality Setting
youtube-dl -f $Qual2 $URL
if [[ ! -f $File2 ]]; then
  echo
  echo "Error audio file not downloaded"
  exit
fi
mv "$File2" "$File2New"

File1=$File1New
File2=$File2New

#Merge Audio and Video with ffmpeg
#Delete -threads 0 if you have a Single Core CPU
echo
echo "Combining Audio and Video files with FFMpeg"
ffmpeg -i "$File1" -i "$File2" -c copy "$Out"
if [[ -f $Out ]]; then
  echo
  echo "File" $Out "created"
else
  echo
  echo "Error Unable to combine Audio and Video files with FFMpeg"
  exit
fi

#Remove old Files
rm "$File1"
rm "$File2"

