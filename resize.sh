#! /usr/bin/env bash
LG_WIDTH=720
LG_HEIGHT=480

TH_WIDTH=720
TH_HEIGHT=70

echo "Resizing in post images"

FILES=$(find src -iname '*.jpg' -or -iname '*.png' -or -iname '*.gif')
for file in $FILES
do
    echo "Resizing: $file"
    FILENAME=$(basename "$file" | cut -d. -f1)
    convert "$file" -strip -resize "${LG_WIDTH}x${LG_HEIGHT}^" -gravity center -crop "${LG_WIDTH}x${LG_HEIGHT}+0+0" -background black -flatten -filter catrom "t_post/${FILENAME}.jpg"

    convert "t_post/${FILENAME}.jpg" -gravity center -crop "${TH_WIDTH}x${TH_HEIGHT}+0+0" -flatten -filter catrom -extent "${TH_WIDTH}x${TH_HEIGHT}" +repage "t_list/${FILENAME}.jpg"

    jpeg-recompress --method smallfry --accurate --quality high --min 60 "t_post/${FILENAME}.jpg" "t_post/${FILENAME}.jpg"
    jpeg-recompress --method smallfry --quality medium --min 60 "t_post/${FILENAME}.jpg" "t_post/${FILENAME}.jpg"
done
echo "Resizing complete"
