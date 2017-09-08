#!/bin/sh
# $1: tile number
# $2: d (dilated)
# $3: table representations (sorted by K, OA, AA or Fmoy)
# Saves evaluation numbers of all classifications in ./Eval 
REGION=$1
TILE_SPOT6=$2
DILATED=$3

DIR_BASH=~/DeveloppementBase/Scripts # Script directory (where master.sh is located)
DIR_EXES=~/DeveloppementBase/Scripts/exes # Executables directory
DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6 # target directory to save S2 and SPOT6 probabilities of tile

bold=$(tput bold)
normal=$(tput sgr0)

cd $DIR_SAVE

mkdir -p Eval

FNAME=Eval/eval.txt
rm -rf $FNAME

# per-tile evaluation
if [ "$DILATED" = "d" ]; then
	GT="train_dilat_bin.rle"
	echo "${bold}Binary${normal} evaluation with ${bold}dilated${normal} ground truth"
else
	GT="train_tout_bin.rle"
	echo "${bold}Binary${normal} evaluation with ${bold}non-dilated${normal} ground truth"
fi

LEGENDE=$DIR_BASH/legende_agg.txt

echo "Methode Kappa OA AA Fmoy F_bat" >> $FNAME
for CLASSIFICATION_DIR in ./Classified/Binary ./Fusion_all/Classified/Binary ./Fusion_all_weighted/Classified/Binary ; do
	for i in $CLASSIFICATION_DIR/*.rle ; do
		CLASSIF_NAME=${i%.rle}
		CLASSIF_NAME=${CLASSIF_NAME##*/}
		echo -n "${CLASSIF_NAME##classif_Fusion_} " >> $FNAME
		$DIR_EXES/Eval $i $GT ./Eval/bm.rle $LEGENDE ./Eval/cf_${CLASSIF_NAME}.txt --Kappa --OA --AA --FScore_moy --FScore_classe 1 >> $FNAME
	done
done

for a in "$@"
do
    if [ "$a" = "K" ]; then
		echo "${bold}Sorted by Kappa:${normal}"
		cat $FNAME|  sort -k2 -r | column -s ' '  -t
	elif [ "$a" = "OA" ]; then
		echo "${bold}Sorted by OA:${normal}"
		cat $FNAME|  sort -k3 -r | column -s ' '  -t
	elif [ "$a" = "AA" ]; then
		echo "${bold}Sorted by AA:${normal}"
		cat $FNAME|  sort -k4 -r | column -s ' '  -t
	elif [ "$a" = "Fmoy" ]; then
		echo "${bold}Sorted by Fmoy:${normal}"
		cat $FNAME|  sort -k5 -r | column -s ' '  -t
	elif [ "$a" = "Bat" ]; then
		echo "${bold}Sorted by F_Bat:${normal}"
		cat $FNAME|  sort -k6 -r | column -s ' '  -t
	fi
done

cat ./Eval/eval.txt | column -s ' '  -t >> $FNAME-1
rm $FNAME
mv $FNAME-1 $FNAME
