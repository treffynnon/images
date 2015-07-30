#! /usr/bin/env bash
LG_WIDTH=720
LG_HEIGHT=480

TH_WIDTH=720
TH_HEIGHT=70

echo "Resizing in post images"
FILES=$(find src -iname '*.jpg' -or -iname '*.png' -or -iname '*.gif')

# process the large images
parallel -j8 convert {} -strip -resize "${LG_WIDTH}x${LG_HEIGHT}^" -gravity center -crop "${LG_WIDTH}x${LG_HEIGHT}+0+0" -filter catrom "t_post/{/}" ::: $FILES

# process the image slices
parallel -j8 convert "t_post/{/}" -gravity center -crop "${TH_WIDTH}x${TH_HEIGHT}+0+0" -filter catrom -extent "${TH_WIDTH}x${TH_HEIGHT}" +repage "t_list/{/}" ::: $FILES

# compress jpg images
parallel -j8 jpeg-recompress --method smallfry --quality medium --min 60 "{}" "{}" ::: t_post/*.jpg
parallel -j8 jpeg-recompress --method smallfry --quality low --min 50 "{}" "{}" ::: t_list/*.jpg

# compress png images
parallel -j8 optipng -o 3 -fix -preserve "{}" -out "{}" ::: t_post/*.png
parallel -j8 optipng -o 3 -fix -preserve "{}" -out "{}" ::: t_list/*.png
parallel -j8 advdef --shrink-extra -z "{}" ::: t_post/*.png
parallel -j8 advdef --shrink-extra -z "{}" ::: t_list/*.png

echo " "
echo "Completed resize operation"
