#!bin/bash
bold=$(tput bold)
normal=$(tput sgr0)

if [ $# -lt 2 ]
  then
    return "At least two arguments expected"
fi

# get two input files and copy them to a target directory for fusion
C1NAME=$1 # SPOT6 tile name (p. ex. "41000_30000")
C2NAME=$2 # S2 tile name (p. ex. "proba_L93")
RAMDIR="/home/cyrilwendl/Documents/tmp"

C1DIR="/home/cyrilwendl/finistere1/test_$C1NAME/classification_results/preds" # classification file SPOT6
C2DIR="/media/cyrilwendl/Data/Images_S2_finistere" # classification directory S2
DNAME="$RAMDIR/im_$C1NAME" # target directory

mkdir $RAMDIR/im_$C1NAME
cd $DNAME

cp ~/DeveloppementBase/Scripts/legende.txt $RAMDIR/im_$C1NAME/legende.txt # copy legend

echo "${bold}Extract files and obtain probabilities (SPOT 6)${normal}"
cd $C1DIR
count=`ls -1 *.csv 2>/dev/null | wc -l`
if ([ $count = 0 ] || [ "$3" = "redo" ])
then 
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
		~/DeveloppementBase/exes/Ech_noif ClassifTristanCSV2TIF pixelwiseListFiles.csv pixelwiseListLabels.csv proba.tif > /dev/null # extract probabilities (silent)
	fi
fi 

cp proba.tif $DNAME/proba_SPOT6.tif # copy to target directory
cp ../../../verifavancement/classif_test_$C1NAME.visu.tfw $DNAME/proba_SPOT6.tfw # copy tfw to target directory
cd $DNAME

echo "${bold}Crop S2 probability${normal}"
bash ~/DeveloppementBase/Scripts/raster_crop_resize.sh $C2DIR/$C2NAME.tif $DNAME/proba_SPOT6.tif $DNAME/proba_S2.tif
cp proba_SPOT6.tfw proba_S2.tfw
