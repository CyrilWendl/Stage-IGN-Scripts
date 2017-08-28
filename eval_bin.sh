#!/bin/sh
# $1: tile number
# $2: d (dilated)
# $3: table representations (sorted by K, OA, AA or Fmoy)
# Saves evaluation numbers of all classifications in ./Eval 
cd ~/fusion/im_$1

bold=$(tput bold)
normal=$(tput sgr0)


rm -rf ./Eval
mkdir ./Eval

FNAME=./Eval/eval.txt
rm -rf $FNAME
# per-tile evaluation


if [ "$2" = "d" ]; then
	GT="train_dilat_bin.rle"
	echo "${bold}Binary${normal} evaluation with ${bold}dilated${normal} ground truth"
else
	GT="train_tout_bin.rle"
	echo "${bold}Binary${normal} evaluation with ${bold}non-dilated${normal} ground truth"
fi

LEGENDE=~/DeveloppementBase/Scripts/legende_agg.txt

echo "Methode Kappa OA AA Fmoy F_bat" >> $FNAME
for CLASSIFICATION_DIR in ./Classified/Binary ./Fusion_all/Classified/Binary ./Fusion_all_weighted/Classified/Binary ; do # ./Walid
	for i in $CLASSIFICATION_DIR/*.rle ; do
		CLASSIF_NAME=${i%.rle}
		CLASSIF_NAME=${CLASSIF_NAME##*/}
		echo -n "${CLASSIF_NAME##classif_Fusion_} " >> $FNAME
		~/DeveloppementBase/exes/Eval $i $GT ./Eval/bm.rle $LEGENDE ./Eval/cf_${CLASSIF_NAME}.txt --Kappa --OA --AA --FScore_moy --FScore_classe 1 >> $FNAME
	done
done
#echo eval.txt

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
