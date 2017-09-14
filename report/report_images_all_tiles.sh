# Convert big TIFs to JPEGs
DIR=/media/cyrilwendl/15BA65E227EC1B23/finistere/all
DIR_EXES=~/DeveloppementBase/Scripts/exes # Executables directory

function gdal_size() {
	SIZE=$(gdalinfo $1 |\
		grep 'Size is ' |\
		cut -d\   -f3-4 |\
		sed 's/,//g' | sed 's/ /X/g')
	echo -n "$SIZE"
}


cd $DIR
# Save in folder /JPEG
rm -rf JPEG/*
mkdir -p JPEG
cd JPEG

gdal_translate -of JPEG -ot Byte $DIR/all_Im_SPOT6_resized.tif all_Im_SPOT6_resized.jpg
SIZE=$(gdal_size ../all_Im_SPOT6_resized.tif)

SEG=""
for CUT in 3 8 15 20 30 50 70 90; do
	SEG=$SEG"all_regul_seg_maj_$CUT "
done

# binary: segmentation, fusion, regul, add overlay
CROP=20 # crop % with respect to SPOT6 image
rm -rf bashtmp.sh makefiletmp
touch bashtmp.sh
for gt in bdtopo osm oso; do
	continue
	convert $DIR/gt/train_$gt.visu.tif $DIR/all_train_$gt.tif
done

for file in all_train_bdtopo all_train_osm all_train_oso all_classif_Fusion_Min all_regul_Min_l1000_g30_e500_0_0_0 $SEG ; do 
	# Overlay SPOT6 on binary images
	echo -n "convert $DIR/$file.tif -resize $SIZE $file.jpg;" >> bashtmp.sh
	echo -n "composite -blend 50% all_Im_SPOT6_resized.jpg ${file}.jpg ${file}_o.jpg;" >> bashtmp.sh
	echo -n "convert  ${file}_o.jpg -resize ${CROP}% ${file}_overlay.jpg;" >> bashtmp.sh
	echo "rm -rf ${file}_o.jpg ${file}.jpg" >> bashtmp.sh
done
$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 3
rm makefiletmp bashtmp.sh


# 5 classes:
touch bashtmp.sh
for file in all_regul_Min_weighted_G2_l1000_g70_e500_0_0_0 all_classif_SPOT6 all_classif_Fusion_Min_weighted all_classif_S2; do
	echo "convert $DIR/$file.tif -resize 10% $file.jpg" >> bashtmp.sh
done
$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
x=$(free -m | awk 'FNR == 2 {print $7}') # get amount of free memory [mb]
rampercore=2 # how much ram one core task needs
cores=$(expr $x / 1024 / $rampercore) # how many cores can be allocated
echo "Available cores: $cores"
make -f makefiletmp -j $cores
rm makefiletmp bashtmp.sh
