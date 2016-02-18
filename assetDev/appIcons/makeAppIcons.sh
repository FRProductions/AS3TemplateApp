#!/bin/bash

# usage text
USGTXT="usage: ./makeAppIcons.sh path/to/1024x1024-icon.png path/to/target/directory"

# validate arguments
# check count
if [ $# -ne 2 ]; then
  echo $USGTXT
  exit 2
fi

# ensure ImageMagick is available
command -v convert >/dev/null 2>&1 || { echo >&2 "ImageMagick is required by this script."; exit 1; }

# define inputs
SRCPTH=$1
TGTDIR=$2
FILPFX="AppIcon"
echo "Input app icon: $SRCPTH"
echo "Output directory: $TGTDIR"

# helper function
function resizeAndMove {
  TGTFNM=$FILPFX$1"x"$1".png"
  echo "resizing $TGTFNM ..."
  convert $SRCPTH -resize $1"x"$1 $TGTFNM
  mv $TGTFNM $TGTDIR"/"$TGTFNM
}

# resize all from original
resizeAndMove "16"
resizeAndMove "29"
resizeAndMove "32"
resizeAndMove "36"
resizeAndMove "40"
resizeAndMove "48"
resizeAndMove "50"
resizeAndMove "57"
resizeAndMove "58"
resizeAndMove "72"
resizeAndMove "76"
resizeAndMove "80"
resizeAndMove "96"
resizeAndMove "100"
resizeAndMove "114"
resizeAndMove "120"
resizeAndMove "128"
resizeAndMove "144"
resizeAndMove "152"
resizeAndMove "512"
resizeAndMove "1024"

echo "done!"
