#!/usr/bin/env bash

# Requires package "imagemagick".

for f in *.png
do convert $f \
  \( +clone  -alpha extract \
    -draw 'fill black polygon 0,0 0,8 8,0 fill white circle 8,8 8,0' \
    \( +clone -flip \) -compose Multiply -composite \
    \( +clone -flop \) -compose Multiply -composite \
  \) -alpha off -compose CopyOpacity -composite $f
done
