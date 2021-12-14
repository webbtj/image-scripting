#!/bin/bash

# that same max size again, when we put this all together, we'll only need one
max=23000

# divisor, this will be used to calculate the scale percetage of different sizes
div=$(bc <<<"scale=2;$max/100")

for x in 10000 2000 500; do
	# the percentage to scale to
	p=$(bc <<<"scale=2;$x/$div")

	# use convert to scale the full size images to smaller versions
	convert \
		-resize ${p}% \
		./img/lightbulb-black-${max}.png \
		./img/lightbulb-black-${x}.png
	convert \
		-resize ${p}% \
		./img/lightbulb-white-${max}.png \
		./img/lightbulb-white-${x}.png
done