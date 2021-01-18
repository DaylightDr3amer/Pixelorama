# This is a script to export all the svg icons to png without going mad

# DISCLAIMER: This is not a part of PixelOrama and it shouldn't be included in the export,
# it's just a way to automate a very specific contnt-creation task, so don't let this script confuse you.

# REQUIREMENTS: Inkscape, ImageMagick, Linux (or something that support bash scripts)

echo "Utitlity started, exporting icons..."

INKSCAPE=/home/entity/Desktop/Programs/Inkscape.AppImage
# Path to the Inkscape executable

MAGICK=/home/entity/Desktop/Programs/magick
# Path to the ImageMagick executable

BANNEDWORD=mirror
# To prevent issues with the mirror icons, I don't know if it works with more than one word

for vector in ./*.svg; do
	echo $vector | grep --quiet "${BANNEDWORD}"
	if [ $? = 1 ] ; then
		# Do the banned word check

		png=$(echo $vector | sed "s/.svg/.png/")
		echo "Exporting ${png} ..."
		$INKSCAPE $vector --export-filename=$png --export-area-page
		# Call Inkscape and export the svg file

		echo "re-coloring image..."

		$MAGICK ./left.png $png -channel-fx "| alpha=>alpha" $(echo $png | sed "s/.png/_l.png/")
		$MAGICK ./right.png $png -channel-fx "| alpha=>alpha" $(echo $png | sed "s/.png/_r.png/")
		$MAGICK ./leftright.png $png -channel-fx "| alpha=>alpha" $(echo $png | sed "s/.png/_l_r.png/")
		# Color each version of the image (left, right and leftright) by applying the original alpha channel to a pre-made texture
	fi
done
# This operation is done for each file every time this script gets called
