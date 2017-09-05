REGION=$1
TILE_SPOT6=$2

DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6/gt

DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
DIR_EXES=$DIR_BASH/exes

# extract buildings from BDTOPO
mkdir -p $DIR_SAVE
cd $DIR_SAVE

$DIR_EXES/Legende label2masqueunique $DIR_BASH/legende.txt ../train_tout.rle 1 train_bdtopo.tif # get binary mask of regulation (buildings)

# dilate
SE_SIZE_DILAT=12
SE_SIZE_EROD=10
#$DIR_EXES/Ech_noif Dilat train_bdtopo.tif 20 train_bdtopo.tif
for i in {1..9}; do
	$DIR_EXES/Ech_noif Dilat train_bdtopo.tif $SE_SIZE_DILAT train_bdtopo.tif
	$DIR_EXES/Ech_noif Erod train_bdtopo.tif $SE_SIZE_EROD train_bdtopo.tif
done
$DIR_EXES/Ech_noif Dilat train_bdtopo.tif $SE_SIZE_DILAT train_bdtopo.tif

cp ../train.visu.tfw train_bdtopo.tfw
gdal_translate -of JPEG -ot Byte -scale -co worldfile=yes train_bdtopo.tif train_bdtopo.jpg

rm -rf *.log *.xml log.txt *.wld

