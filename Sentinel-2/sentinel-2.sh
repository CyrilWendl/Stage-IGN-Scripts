# Sentinel-2 resizing for classification
# FRE: image in ground reflectance with the correction of slope effects
# Bands of 10m resolution: 2,3,4,8
# Bands of 20m resolution: 5,6,7,8a,11,12

DIR_S2=/media/cyrilwendl/15BA65E227EC1B23/gironde/Data/Sentinel-2 				# Downloaded images
DIR_OUT=/media/cyrilwendl/15BA65E227EC1B23/gironde/Data/Classif_Sentinel-2		# Resized images
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts								# Script folder

mkdir -p $DIR_OUT
cd $DIR_S2
for i in *V1*/; do
	echo "Directory $i:"
	cd $DIR_S2/$i
	DATE=$(pwd|cut -d "_" -f2-|cut -d "-" -f1)
	rm -Rf $DIR_OUT/$DATE
	mkdir -p $DIR_OUT/$DATE
	for j in 5 6 7 8A 11 12; do
		ls *FRE_B$j.tif
		bash $DIR_BASH/raster-resize.sh *FRE_B$j.tif *FRE_B2.tif $DIR_OUT/$DATE/B$j.tif
		listgeo -tfw $DIR_OUT/$DATE/B$j.tif
		convert_ori tfw2ori $DIR_OUT/$DATE/B$j.tfw $DIR_OUT/$DATE/B$j.ori
	done
	for j in 2 3 4 8; do
		cp *FRE_B$j.tif $DIR_OUT/$DATE/B$j.tif
		listgeo -tfw $DIR_OUT/$DATE/B$j.tif
		convert_ori tfw2ori $DIR_OUT/$DATE/B$j.tfw $DIR_OUT/$DATE/B$j.ori
	done
done

# TODO cp emprise.ori
