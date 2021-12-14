#!/bin/bash

# we end up using these over and over, so best to create variables
svg=./img/lightbulb.svg
max=23000

# use Inkscape to width and height of the svg
W=$(inkscape -W ${svg})
H=$(inkscape -H ${svg})

# a variable to hold which dimension (width/height) is larger
dim="--export-width="

# bc is a language with arbitrary precision, -l loads the standard mathlib
# basically this is used for precision, which is more important later
if (( $(echo "$H > $W" |bc -l) )); then
	dim="--export-height="
fi

# using the inkscape cli load the svg from step 1
# export the svg "page" to a png file
# set either the width or the height, which ever is larger, to the max
inkscape \
	--export-area-page \
	--export-type="png" \
	${dim}${max} \
	--export-filename=./img/lightbulb-black-${max}.png \
	${svg}