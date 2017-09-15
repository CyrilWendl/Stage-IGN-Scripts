# extract buildings from BDTOPO
cd $DIR_SAVE

$DIR_EXES/Legende label2masqueunique $DIR_BASH/legende.txt ../train_tout.rle 1 train_bdtopo.tif # get binary mask of regulation (buildings)
cp train_bdtopo.tif train_bdtopo_original.tif 

# dilate
SE_SIZE_DILAT=3
SE_SIZE_EROD=2
#$DIR_EXES/Ech_noif Dilat train_bdtopo.tif 20 train_bdtopo.tif
for i in {1..9}; do
	$DIR_EXES/Ech_noif Dilat train_bdtopo.tif $SE_SIZE_DILAT train_bdtopo.tif
	$DIR_EXES/Ech_noif Erod train_bdtopo.tif $SE_SIZE_EROD train_bdtopo.tif
done
$DIR_EXES/Ech_noif Dilat train_bdtopo.tif $SE_SIZE_DILAT train_bdtopo.tif
cp ../train.visu.tfw train_bdtopo.tfw
gdal_translate -of GTiff -ot Byte train_bdtopo.tif train_bdtopo2.tif
mv train_bdtopo2.tif train_bdtopo_dilat.tif
rm -rf *.log *.xml log.txt *.wld
