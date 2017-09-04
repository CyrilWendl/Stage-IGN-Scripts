# Resize a GTiff raster to resolution of a second GTiff raster
# resize_crop_raster.sh [raster_to_resize] [raster] [out_raster]

if [ $# -lt 3 ]
	then
	exit
fi
RASTER_TO_RESIZE=$1
RASTER=$2
OUT_RASTER=$3

function gdal_size() {
	SIZE=$(gdalinfo $1 |\
		grep 'Size is ' |\
		cut -d\   -f3-4 |\
		sed 's/,//g')
	echo -n "$SIZE"
}

# resize big raster
gdalwarp -ts $(gdal_size $RASTER) -r bilinear $RASTER_TO_RESIZE $OUT_RASTER
