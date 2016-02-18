#!/bin/bash

# source file
SRCFNM="Default-Landscape@2x.png"

# usage: cropAndResize "outputFilename" "width" "height" ("" or "-flip")
function cropAndResize {
  echo $1...
  convert $SRCFNM $4 -resize $2"x"$3 -gravity center -crop $2"x"$3"+0+0!" -background "#000000" -flatten $1
}

# create launch screens
cropAndResize "Default-568h@2x.png" "1136" "640" ""         # iPhone 5
cropAndResize "Default-667w-375h@2x.png" "1334" "750" ""    # iPhone 6

# clean target dir and copy new images
TGTDIR=../../../assets/images/launchScreens/iOS
rm $TGTDIR/*.png
cp -v *.png $TGTDIR

echo "done!"
