# Convert OSO to GT labels
REGION=$1
TILE_SPOT6=$2

mkdir -p $DIR_SAVE_GT
cd $DIR_OSO
rm -rf masktmp
mkdir -p masktmp

# remove color table
#gdal_translate -co COMPRESS=LZW -ot Int16 OCS_2016_CESBIO.tif OCS_2016_CESBIO_nocolor2.tif

# crop extent
rm -rf *crop*
bash $DIR_BASH/tools/raster_crop_resize.sh OCS_2016_CESBIO_nocolor.tif $EXTENT OCS_2016_CESBIO_crop_color.tif
# remove color table
gdal_calc.py -A OCS_2016_CESBIO_crop_color.tif --outfile=OCS_2016_CESBIO_crop.tif --calc="A*1" --NoDataValue=0

# convert labels
$DIR_EXES/Legende label2masqueunique nomenclature_oso.txt OCS_2016_CESBIO_crop.tif 41 42 43 masktmp/urbain.tif
$DIR_EXES/Legende label2masqueunique nomenclature_oso.txt OCS_2016_CESBIO_crop.tif 11 12 31 32 34 36 45 46 51 53 211 221 222 44 masktmp/nonurbain.tif

# merge labels
$DIR_EXES/Legende masques2label $DIR_BASH/legende_agg_oso.txt masktmp/ train_oso.tif
rm -Rf *.log log.* *.xml *.wld masktmp/ *crop*
mv train_oso* $DIR_SAVE_GT/
cp $DIR_SAVE_GT/../Im_SPOT6.tfw train_oso.tfw
