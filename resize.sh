#! /usr/bin/env bash
LG_WIDTH=720
LG_HEIGHT=480

TH_WIDTH=720
TH_HEIGHT=70

TOUCHFILE="simonholywell-images.lastrun.time"

if [ ! -f "$TOUCHFILE" ]; then
    LAST_COMMIT_TIMESTAMP=$(git show -s --format=%ct)
    touch -d "@$LAST_COMMIT_TIMESTAMP" "$TOUCHFILE"
fi

echo "Resizing in post images"
FILES=$(find src -newer "$TOUCHFILE" -iname '*.jpg' -or -newer "$TOUCHFILE" -iname '*.png' -or -newer "$TOUCHFILE" -iname '*.gif')
echo "$FILES"
if [ -n "$FILES" ]; then
    # process the large images
    parallel -j8 convert "{}" -strip -resize "${LG_WIDTH}x${LG_HEIGHT}^" -gravity center -crop "${LG_WIDTH}x${LG_HEIGHT}+0+0" -filter catrom "t_post/{/}" ::: $FILES

    # process the image slices
    parallel -j8 convert "t_post/{/}" -gravity center -crop "${TH_WIDTH}x${TH_HEIGHT}+0+0" -filter catrom -extent "${TH_WIDTH}x${TH_HEIGHT}" +repage "t_list/{/}" ::: $FILES
fi

# compress jpg images
JPOST_FILES=$(find t_post -newer "$TOUCHFILE" -iname '*.jpg')
JLIST_FILES=$(find t_list -newer "$TOUCHFILE" -iname '*.jpg')
if [ -n "$JPOST_FILES" ]; then
    parallel -j8 jpeg-recompress --method smallfry --quality medium --min 60 "{}" "{}" ::: $JPOST_FILES
fi
if [ -n "$JLIST_FILES" ]; then
    parallel -j8 jpeg-recompress --method smallfry --quality low --min 50 "{}" "{}" ::: $JLIST_FILES
fi

# compress png images
PNG_FILES=$(find t_post t_list -newer "$TOUCHFILE" -iname '*.png')
if [ -n "$PNG_FILES" ]; then
    parallel -j8 optipng -o 3 -fix "{}" -out "{}" ::: $PNG_FILES
    parallel -j8 advdef --shrink-extra -z "{}" ::: $PNG_FILES
fi

echo " "
echo "Completed resize operation"
touch "$TOUCHFILE"
