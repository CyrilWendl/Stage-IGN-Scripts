REGION=$1
TILE_SPOT6=$2

DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6/gt

DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
DIR_EXES=$DIR_BASH/exes

# extract buildings from BDTOPO
mkdir -p $DIR_SAVE
cd $DIR_SAVE

$DIR_EXES/Legende label2masqueunique $DIR_BASH/legende.txt ../train_tout.rle 1 bati.tif # get binary mask of regulation (buildings)

# dilate
$DIR_EXES/Ech_noif Dilat bati.tif 10 train_bdtopo_dilat.tif 
#Ech_noif Chamfrein bati.tif dist.tif
#Pleiades PriorProb:f:c dist.tif 0 1 200 0 $DIR_OUT/proba_regul_urbain.tif

cp ../train.visu.tfw train_bdtopo_dilat.tfw
gdal_translate -of JPEG train_bdtopo_dilat.tif train_bdtopo_dilat.jpg
#rm -rf bati.tif


