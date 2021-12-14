#!/bin/bash

# use convert (imagemagick) to create a bitmap from the jpeg input
# pipe that bitmap to potrace to create the svg
convert \
	-channel RGB \
	-compress None \
	./img/lightbulb.jpeg bmp:- | \
potrace \
	-s - \
	-o ./img/lightbulb.svg
