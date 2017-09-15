# get input probabilities and copy them to a target directory for fusion

echo "${bold}Prepare directory${normal}"
rm -Rf $DIR_SAVE
mkdir $DIR_SAVE


cp $DIR_BASH/../legende.txt $DIR_SAVE/legende.txt # copy legend

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

cp proba.tif $DIR_SAVE/proba_SPOT6.tif # copy to target directory
cd $DIR_DATA/SPOT6_$REGION/image
listgeo -tfw tile_$TILE_SPOT6.tif
cp tile_$TILE_SPOT6.tfw $DIR_SAVE/proba_SPOT6.tfw # copy tfw to target directory

cd $DIR_SAVE

if [ "$2" = "crop" ]; 
	then
	echo "Crop SPOT6 probabilities to ${3} * ${4} window" # Crop SPOT6 probability
	gdal_translate -srcwin ${3} ${4} ${5} ${6} proba_SPOT6.tif proba_SPOT6_crop.tif
	mv proba_SPOT6_crop.tif proba_SPOT6.tif
	listgeo proba_SPOT6.tif -tfw
fi

# Covert .tfw to .ori
$DIR_EXES/convert_ori tfw2ori proba_SPOT6.tfw proba_SPOT6.ori

echo "${bold}Crop and resize S2 probability to SPOT6 probability${normal}"
bash $DIR_BASH_TOOLS/raster_crop_resize.sh $DIR_PROBA_S2/$TILE_S2.tif $DIR_SAVE/proba_SPOT6.tif $DIR_SAVE/proba_S2.tif
cp proba_SPOT6.tfw proba_S2.tfw
