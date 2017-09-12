# Convert OSO to GT labels
REGION=$1
TILE_SPOT6=$2

DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6/gt
DIR_EXTENT=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6/
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
DIR_EXES=$DIR_BASH/exes
DIR_OSO=/media/cyrilwendl/15BA65E227EC1B23/data/OSO

mkdir -p $DIR_SAVE
cd $DIR_OSO
rm -rf masktmp
mkdir -p masktmp

# remove color table
#gdal_translate -co COMPRESS=LZW -ot Int16 OCS_2016_CESBIO.tif OCS_2016_CESBIO_nocolor2.tif

# crop extent
rm -rf *crop*
bash $DIR_BASH/tools/raster_crop_resize.sh OCS_2016_CESBIO_nocolor.tif $DIR_EXTENT/proba_SPOT6.tif OCS_2016_CESBIO_crop_color.tif
# remove color table
gdal_calc.py -A OCS_2016_CESBIO_crop_color.tif --outfile=OCS_2016_CESBIO_crop.tif --calc="A*1" --NoDataValue=0

# convert labels
$DIR_EXES/Legende label2masqueunique nomenclature_oso.txt OCS_2016_CESBIO_crop.tif 41 42 43 masktmp/urbain.tif
$DIR_EXES/Legende label2masqueunique nomenclature_oso.txt OCS_2016_CESBIO_crop.tif 11 12 31 32 34 36 45 46 51 53 211 221 222 44 masktmp/nonurbain.tif

# merge labels
$DIR_EXES/Legende masques2label $DIR_BASH/legende_agg_oso.txt masktmp/ train_oso.tif
rm -Rf *.log log.* *.xml *.wld masktmp/ *crop*
mv train_oso* $DIR_SAVE/
cp $DIR_SAVE/../Im_SPOT6.tfw train_oso.tfw
