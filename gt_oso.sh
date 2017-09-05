# Convert OSO to GT labels
TILE_SPOT6=38500_32500

DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
DIR_EXES=$DIR_BASH/exes
DIR_OSO=/media/cyrilwendl/15BA65E227EC1B23/data/OSO

cd $DIR_OSO
rm -rf masktmp
mkdir -p masktmp

# crop tp toée extemts
rm *crop*
bash $DIR_BASH/tools/raster_crop_resize.sh OCS_2016_CESBIO.tif ../../gironde/detail/im_$TILE_SPOT6/proba_SPOT6.tif OCS_2016_CESBIO_crop_color.tif
# remove color table
gdal_calc.py -A OCS_2016_CESBIO_crop_color.tif --outfile=OCS_2016_CESBIO_crop.tif --calc="A*1" --NoDataValue=0

# convert labels
$DIR_EXES/Legende label2masqueunique nomenclature_oso.txt OCS_2016_CESBIO_crop.tif 41 42 43 masktmp/urbain.tif
$DIR_EXES/Legende label2masqueunique nomenclature_oso.txt OCS_2016_CESBIO_crop.tif 11 12 31 32 34 36 45 46 51 53 211 221 222 44 masktmp/nonurbain.tif

# merge labels
$DIR_EXES/Legende masques2label $DIR_BASH/legende_agg_bin.txt masktmp/ train_oso.rle

# visualize
$DIR_EXES/Legende label2RVB $DIR_BASH/legende_agg_bin.txt train_oso.rle train_oso.visu.tif
