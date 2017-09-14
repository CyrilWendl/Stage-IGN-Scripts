# intersection over union: copy masks to folder Eval_bin
# put all images in one 
REGION=finistere
TILES=(41000_30000 39000_40000 39000_42000 41000_40000 41000_42000)
DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail
DIR_OTB=~/Documents/OTB/OTB-6.0.0-Linux64/bin
cd $DIR_SAVE
#rm -Rf $DIR_SAVE/Eval_bin/*
mkdir -p $DIR_SAVE/Eval_bin

cd $DIR_SAVE/Eval_bin
for TRAIN in train_bdtopo train_oso train_osm; do
	continue
	FILES=""
	for tile in ${TILES[@]}; do
		FILE=$DIR_SAVE/im_$tile/gt/$TRAIN.tif
		cp $FILE ${tile}_$(basename $FILE)
		FILES="$FILES$tile_$(basename $FILE).tif "
	done
	for i in {0..3};do	
		TILE1=${TILES[@]:$i:1}_$(basename $FILE)
		TILE2=${TILES[@]:$i+1:1}_$(basename $FILE)
		$DIR_OTB/otbcli_TileFusion -il $TILE1 $TILE2 -cols 2 -rows 1 -out $TILE2
	done
	mv $TILE2 $DIR_SAVE/Eval_bin/$TRAIN.tif
	for tile in ${TILES[@]}; do
		rm -rf *$tile*
	done
done


for file in regul_seg_maj_8 regul_proba_Fusion_Min_100_1000_100_0_100_70_100_200_0_0_0 classif_regul_urbain classif_S2_urbain classif_Fusion_Min classif_Fusion_Bayes ; do
	continue
	FILES=""
	for tile in ${TILES[@]}; do
		FILE=$DIR_SAVE/im_$tile/gt/eval/$file/$file-resized.tif
		cp $FILE ${tile}_$(basename $FILE)
		FILES="$FILES$tile_$(basename $FILE).tif "
	done
	for i in {0..3};do	
		TILE1=${TILES[@]:$i:1}_$(basename $FILE)
		TILE2=${TILES[@]:$i+1:1}_$(basename $FILE)
		$DIR_OTB/otbcli_TileFusion -il $TILE1 $TILE2 -cols 2 -rows 1 -out $TILE2
	done
	mv $TILE2 $DIR_SAVE/Eval_bin/$file.tif
	for tile in ${TILES[@]}; do
		rm -rf *$tile*
	done
done
rm -rf $DIR_SAVE/Eval_bin/*.xml

# evaluation numbers
mkdir -p CM
rm -rf eval-bin.txt
echo "Classif GT F-Score_bat Kappa OA"  >> eval-bin.txt
for CLASSIF in regul_seg_maj_8 regul_proba_Fusion_Min_100_1000_100_0_100_70_100_200_0_0_0 classif_regul_urbain classif_S2_urbain classif_Fusion_Min classif_Fusion_Bayes ; do
	for GT in train_bdtopo train_oso train_osm; do
		# print IU data
		echo "$CLASSIF, $GT"
		cat $DIR_SAVE/Eval_bin/results/${GT}_new/${CLASSIF}_new/${CLASSIF}_new_IU_Score_1.txt | tail -n 1 |grep -oE "[0-9]*[.][0-9]*"	
		continue
		$DIR_OTB/otbcli_ComputeConfusionMatrix -in $CLASSIF.tif -out CM/${CLASSIF}_$GT.csv -ref raster -ref.raster.in $GT.tif >> CM/${CLASSIF}_$GT.csv
		echo -n "$CLASSIF $GT "  >> eval-bin.txt
		for INFORMATION in "F-score of class \[1\]" "Kappa" "Overall accuracy index"; do
			echo -n "$(cat CM/${CLASSIF}_$GT.csv | grep "$INFORMATION" |grep -oE "[0-9][.][0-9]*") " >> eval-bin.txt
		done
		echo "" >> eval-bin.txt
	done
done

