#!/bin/bash

# ================================ variables ===================================

# the maximum size of the output images
max=23000
# which dimension (width/height) is larger (used with inkscape)
dim="--export-width="
# if your GIMP binary isn't in your path, you can just create a variable
gimp="/Applications/GIMP-2.10.app/Contents/MacOS/gimp"
# divisor, this will be used to calculate the scale percetage of different sizes
div=$(bc <<<"scale=2;$max/100")

# ==============================================================================


for jpg in ./input/*.jpeg; do

	j=${jpg##*/}
	imagename=${j%.jpeg}

	# =============================== step 1 ===================================

	# use convert (imagemagick) to create a bitmap from the jpeg input
	# pipe that bitmap to potrace to create the svg
	convert \
		-channel RGB \
		-compress None \
		./input/${imagename}.jpeg bmp:- | \
	potrace \
		-s - \
		-o ./output/${imagename}.svg

	# we end up using these over and over, so best to create variables
	svg=./output/${imagename}.svg

	# ==========================================================================



	# =============================== step 2 ===================================

	# use Inkscape to width and height of the svg
	W=$(inkscape -W ${svg})
	H=$(inkscape -H ${svg})

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
		--export-filename=./output/${imagename}-black-${max}.png \
		${svg}

	# ==========================================================================



	# =============================== step 3 ===================================

	# run a script-fu (lisp-like) script to invert the black png to white
	${gimp} \
		-i \
		-b "
			(
				let* (
					(
						image (
							car (
								file-png-load
									RUN-NONINTERACTIVE
									\"./output/${imagename}-black-${max}.png\"
									\"./output/${imagename}-black-${max}.png\"
							)
						)
					)
					(
						drawable (
							car (
								gimp-image-active-drawable
									image
							)
						)
					)
				)
				(
					gimp-drawable-invert
						drawable
						TRUE
				)
				(
					gimp-file-save
						RUN-NONINTERACTIVE
						image
						drawable
						\"./output/${imagename}-white-${max}.png\"
						\"./output/${imagename}-white-${max}.png\"
				)
			)
			" \
		-b "(gimp-quit 0)"

	# ==========================================================================



	# =============================== step 4 ===================================

	for x in 10000 2000 500; do
		# the percentage to scale to
		p=$(bc <<<"scale=2;$x/$div")

		# use convert to scale the full size images to smaller versions
		convert \
			-resize ${p}% \
			./output/${imagename}-black-${max}.png \
			./output/${imagename}-black-${x}.png
		convert \
			-resize ${p}% \
			./output/${imagename}-white-${max}.png \
			./output/${imagename}-white-${x}.png
	done

	# ==========================================================================

done