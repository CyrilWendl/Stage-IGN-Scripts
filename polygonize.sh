# Polygonize a raster of pixels of same class for a given classification
TILE_SPOT6=$1

BDIR="/home/cyrilwendl/DeveloppementBase/exes" # base directory for executables
DNAME="/home/cyrilwendl/DeveloppementBase/im_$TILE_SPOT6/Fusion_bat/Classified" # classification directory
FNAME="classif_Fusion_DS_MasseV1" # classification file name

cd $DNAME 

# 1. create a binary mask (0 | 1) for pixels classified as urban or not
$BDIR/Legende label2masqueunique legende.txt $FNAME.rle 1 $FNAME"_"urbain.tif
FNAME="classif_Fusion_DS_MasseV1_urbain" # classification file name
 
# 2. create polygons from binary mask
gdal_polygonize.py -8 $DNAME/$FNAME.tif -mask $DNAME/$FNAME.tif -f "ESRI Shapefile" $DNAME/$FNAME-POLY.shp $FNAME-POLY FIELD

nautilus .
