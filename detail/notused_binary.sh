REGION=$1
TILE_SPOT6=$2

BDIR="/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6"
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
