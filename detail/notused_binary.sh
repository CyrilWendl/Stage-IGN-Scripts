# input: 
# 1: tile number 

if [ $# -lt 1 ]
  then
    return "At least one  argument expected: tile number"
fi

BDIR="/home/cyrilwendl/fusion/im_$1"
cd $BDIR

## CONVERSION BINAIRE
LEGENDE=~/DeveloppementBase/Scripts/legende_agg.txt

# Classifications probas d'entrée
for DNAME in "$BDIR" "$BDIR/Fusion_all" "$BDIR/Fusion_all_weighted" ;do	
	rm -Rf $DNAME/Classified/Binary
	mkdir $DNAME/Classified/Binary
	cd $DNAME/Classified/Binary
	for i in $DNAME/Classified/*.rle ; do # all classification ending in .rle
		CLASSIF_NAME=${i%.rle}
		CLASSIF_NAME=${CLASSIF_NAME##*/}
		#echo $CLASSIF_NAME 
		#echo -n $CLASSIFICATION_DIR"/ "$CLASSIF_NAME" " >> $FNAME
		#~/DeveloppementBase/exes/Eval $i $GT ./Eval/bm.rle $LEGENDE ./Eval/cf_${CLASSIF_NAME}.txt --Kappa --OA --AA --FScore_moy >>
		 $FNAME
			~/DeveloppementBase/exes/Legende aggrege $LEGENDE ${DNAME}/Classified/$CLASSIF_NAME.rle ${DNAME}/Classified/Binary/${CLASSIF_NAME}_bin.rle
	done
done
echo "Done"
