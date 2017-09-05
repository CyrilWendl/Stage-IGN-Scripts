# Crop resize a GTiff raster to the extent and resolution of a second GTiff raster
# resize_crop_raster.sh [big_raster] [small_raster] [out_raster]

if [ $# -lt 3 ]
	then
	exit
fi
BIG_RASTER=$1
SMALL_RASTER=$2
OUT_RASTER=$3
TMPDIR=$(dirname $SMALL_RASTER)

function gdal_size() {
	SIZE=$(gdalinfo $1 |\
		grep 'Size is ' |\
		cut -d\   -f3-4 |\
		sed 's/,//g')
	echo -n "$SIZE"
}

# create extent from small raster
gdaltindex -t_srs EPSG:2154 -src_srs_name src_srs $TMPDIR/tmp.shp $SMALL_RASTER

# crop and resize big raster
gdalwarp -cutline $TMPDIR/tmp.shp -crop_to_cutline -dstnodata 0 -ts $(gdal_size $SMALL_RASTER) -r bilinear $BIG_RASTER $OUT_RASTER

rm -rf $TMPDIR/tmp*
