#!/bin/bash

# Usage   ./myscript.sh -e conf -s /etc -l /usr/lib /etc/hosts 
# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )

usage="$(basename "$0") [-h] [-o pathToOutputDir] -f|-b image

where:
    -h  				show this help text
    -o path 			the path where to save the output
    -f image  			resize image to front-cover size (12,1cmx12,1cm)
    -b image			resize image to cd-back size (15,1cmx11,8cm).
    					This option will overwrite -f.

Resizes the given image to a printing size (600x600dpi)so that it fits into a cd cover.
This program does not touch the original file but creates a new one.
The new file will be called front.png respectively back.png

Dependencies: uses ImageMagick" 

# my variables
front=1
outputpath="$(pwd)"

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

while getopts "h?f:b:o:" opt; do
    case "$opt" in
    h|\?)
        echo "$usage"
        exit 0
        ;;
    f)  front=1
		image=$OPTARG
        ;;
    b)	front=0
		image=$OPTARG
		;;
    o)  outputpath=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

# tu iwas mit übrigen argumenten 

# image has not been initialized or not declared
if [ -z ${image+x} ]
then
	echo "No image source."
	echo "$usage"
	exit -1
fi

if [ "$front" -eq "1" ]
then
	convert "$image" -resize 2860x2860! -density 600x600 "$outputpath/front.png"
else
	convert "$image" -resize 3567x2787! -density 600x600 "$outputpath/back.png"
fi
