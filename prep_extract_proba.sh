
# multi-core version
# gironde
cd /media/cyrilwendl/15BA65E227EC1B23/gironde/data/SPOT6_gironde/proba
x=$(ls | cut -d_ -f2-3)
tiles=""
for e in $x; do
	inx=$(echo $e | cut -d_ -f1| awk '$0 < 40500') # y value	
	iny=$(echo $e | cut -d_ -f2| awk '$0 > 10500') # y value	
	if [ ! -z $inx ] && [ ! -z $iny ]; 
		then
		tiles="$tiles$e "
	fi
done
echo $tiles

DIR_EXES=~/DeveloppementBase/exes # Executables directory
DIR_DATA=/media/cyrilwendl/15BA65E227EC1B23/gironde/data
rm -rf $DIR_DATA/bashtmp.sh $DIR_DATA/makefiletmp
touch $DIR_DATA/bashtmp.sh
for tile in $tiles;do
	echo $tile
	DIR_PROBA_SPOT6=$DIR_DATA/SPOT6_gironde/proba/test_$tile/classification_results/preds # probability SPOT6
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
			echo -n "tar -jxvf pixelwiseListFiles.csv.tar.bz2;" >> $DIR_DATA/bashtmp.sh
			echo "tar -jxvf pixelwiseListLabels.csv.tar.bz2" >> $DIR_DATA/bashtmp.sh
		fi
		echo "$DIR_EXES/Ech_noif ClassifTristanCSV2TIF pixelwiseListFiles.csv pixelwiseListLabels.csv proba.tif > /dev/null" >> $DIR_DATA/bashtmp.sh # extract probabilities (silent)
	fi	
done
$DIR_EXES/Bash2Make $DIR_DATA/bashtmp.sh $DIR_DATA/makefiletmp # MakeFile compilation
make -f $DIR_DATA/makefiletmp -j 16
rm $DIR_DATA/makefiletmp $DIR_DATA/bashtmp.sh
echo "DONE"

exit
# single-core version
# gironde
cd /media/cyrilwendl/15BA65E227EC1B23/gironde/data/SPOT6_gironde/proba
x=$(ls | cut -d_ -f2-3)
tiles=""
for e in $x; do
	inx=$(echo $e | cut -d_ -f1| awk '$0 < 40500') # y value	
	iny=$(echo $e | cut -d_ -f2| awk '$0 > 10500') # y value	
	if [ ! -z $inx ] && [ ! -z $iny ]; 
		then
		tiles="$tiles$e "
	fi
done
echo $tiles

DIR_EXES=~/DeveloppementBase/exes # Executables directory
DIR_DATA=/media/cyrilwendl/15BA65E227EC1B23/gironde/data
for tile in $tiles;do
	echo $tile
	DIR_PROBA_SPOT6=$DIR_DATA/SPOT6_gironde/proba/test_$tile/classification_results/preds # probability SPOT6
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
	
done


