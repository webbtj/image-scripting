#!/bin/bash

# if your GIMP binary isn't in your path, you can just create a variable
gimp="/Applications/GIMP-2.10.app/Contents/MacOS/gimp"
max=23000

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
								\"./img/lightbulb-black-${max}.png\"
								\"./img/lightbulb-black-${max}.png\"
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
					\"./img/lightbulb-white-${max}.png\"
					\"./img/lightbulb-white-${max}.png\"
			)
		)
		" \
	-b "(gimp-quit 0)"