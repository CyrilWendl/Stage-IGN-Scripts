# intersection over union: copy masks to folder Eval_bin
REGION=$1

if [ $REGION = "finistere" ]; then
	TILES=(41000_30000 39000_40000 39000_42000 41000_40000 41000_42000)
elif [ $REGION = "gironde" ]; then
	TILES=(24500_18500 26500_18500 24500_20500 26500_20500 28500_32500 30500_30500)
fi

DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail
DIR_OTB=~/Documents/OTB/OTB-6.0.0-Linux64/bin
cd $DIR_SAVE
#rm -Rf $DIR_SAVE/Eval_bin/*
mkdir -p $DIR_SAVE/Eval_bin

# merge all five tiles
cd $DIR_SAVE/Eval_bin
for TRAIN in train_bdtopo train_oso train_osm; do
	FILES=""
	for tile in ${TILES[@]}; do
		FILE=$DIR_SAVE/im_$tile/gt/$TRAIN.tif
		cp $FILE ${tile}_$(basename $FILE)
		FILES="$FILES$tile_$(basename $FILE).tif "
	done
	for ((i=0; i<=${#TILES[@]}-2; i++)); do
		TILE1=${TILES[@]:$i:1}_$(basename $FILE)
		TILE2=${TILES[@]:$i+1:1}_$(basename $FILE)
		$DIR_OTB/otbcli_TileFusion -il $TILE1 $TILE2 -cols 2 -rows 1 -out $TILE2
	done
	mv $TILE2 $DIR_SAVE/Eval_bin/$TRAIN.tif
	for tile in ${TILES[@]}; do
		rm -rf *$tile*
	done
done


for file in classif_regul_urbain classif_S2_urbain classif_Fusion_Min regul_proba_Fusion_Min_100_1000_100_0_100_70_100_200_0_0_0 regul_seg_maj_8; do
	FILES=""
	for tile in ${TILES[@]}; do
		FILE=$DIR_SAVE/im_$tile/gt/eval/$file/$file-resized.tif
		cp $FILE ${tile}_$(basename $FILE)
		FILES="$FILES$tile_$(basename $FILE).tif "
	done
	for ((i=0; i<=${#TILES[@]}-2; i++)); do
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
echo "Classif GT F-Score_bat Kappa OA IoU_b"  >> eval-bin.txt
for CLASSIF in classif_regul_urbain classif_S2_urbain classif_Fusion_Min regul_proba_Fusion_Min_100_1000_100_0_100_70_100_200_0_0_0 regul_seg_maj_8; do
	for GT in train_bdtopo train_oso train_osm; do
		# Confusion Matrix
		$DIR_OTB/otbcli_ComputeConfusionMatrix -in $CLASSIF.tif -out CM/${CLASSIF}_$GT.csv -ref raster -ref.raster.in $GT.tif >> CM/${CLASSIF}_$GT.csv

		echo -n "$CLASSIF $GT " >> eval-bin.txt
		for INFORMATION in "F-score of class \[1\]" "Kappa" "Overall accuracy index"; do
			echo -n "$(cat CM/${CLASSIF}_$GT.csv | grep "$INFORMATION" |grep -oE "[0-9][.][0-9]*") " >> eval-bin.txt
		done
		one=($(cat CM/${CLASSIF}_$GT.csv | grep "1\]" | grep "\[ " | grep -oE "[0-9]{2,}" | tr '\n' ' '))
		zero=($(cat CM/${CLASSIF}_$GT.csv | grep "0\]" | grep "\[ " | grep -oE "[0-9]{2,}" | tr '\n' ' '))
		# Intersection over union
		IoU_b=$(awk "BEGIN{print ${one[@]:1:1}/(${one[@]:0:1} + ${one[@]:1:1} + ${zero[@]:1:1})}")
		echo "$IoU_b " >> eval-bin.txt
	done
done

