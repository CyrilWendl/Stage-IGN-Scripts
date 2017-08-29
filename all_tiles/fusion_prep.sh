# get two input files and copy them to a target directory for fusion
DIR_TMP="$DIR_RAM/im_$TILE_SPOT6" # target directory

mkdir $DIR_RAM/im_$TILE_SPOT6
cd $DIR_TMP

cp $DIR_BASH/legende.txt $DIR_RAM/im_$TILE_SPOT6/legende.txt # copy legend

echo "${bold}Extract files and obtain probabilities (SPOT 6)${normal}"
cd $DIR_PROBA_SPOT6

if [ -f "proba.tif" ] # check if probabilities already extracted
	then
	echo "Proba file exists. Will copy to new directory."
else
	ls
	if [ -f "pixelwiseListLabels.csv" ]
		then
		echo "CSV exists. Will produce proba"
	else
		echo "Extracting files..."
		tar -jxvf pixelwiseListFiles.csv.tar.bz2
		tar -jxvf pixelwiseListLabels.csv.tar.bz2
	fi
	$DIR_EXES/Ech_noif ClassifTristanCSV2TIF pixelwiseListFiles.csv pixelwiseListLabels.csv proba.tif > /dev/null # extract probabilities (silent)
fi

cp proba.tif $DIR_TMP/proba_SPOT6.tif # copy to target directory
cd $DIR_DATA/SPOT6_$REGION/image
listgeo -tfw tile_$TILE_SPOT6.tif
cp tile_$TILE_SPOT6.tfw $DIR_TMP/proba_SPOT6.tfw # copy tfw to target directory

cd $DIR_TMP

echo "${bold}Crop S2 probability${normal}"
bash ~/DeveloppementBase/Scripts/raster_crop_resize.sh $DIR_PROBA_S2/$TILE_S2.tif $DIR_TMP/proba_SPOT6.tif $DIR_TMP/proba_S2.tif
cp proba_SPOT6.tfw proba_S2.tfw
