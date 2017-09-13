# intersection over union: copy masks to folder Eval_bin
# put all images in one 
REGION=finistere
TILES=(41000_30000 39000_40000 39000_42000 41000_40000 41000_42000)
DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail
cd $DIR_SAVE
rm -Rf $DIR_SAVE/Eval_bin
mkdir -p $DIR_SAVE/Eval_bin


for file in train_bdtopo train_oso train_osm; do
	FILES=""
	for tile in ${TILES[@]}; do
		echo $tile
		gdal_translate -of JPEG -ot Byte $DIR_SAVE/im_$tile/gt/$file.tif $DIR_SAVE/Eval_bin/$file$tile.tif
		FILES="$FILES$file$tile.tif "
	done
	cd $DIR_SAVE/Eval_bin
	for i in {0..4};do
		TILE1=${TILES[@]:$i:1}
		TILE2=${TILES[@]:$i+1:1}
		~/Documents/OTB/OTB-6.0.0-Linux64/bin/otbcli_TileFusion -il $file$TILE1.tif $file$TILE2.tif -cols 2 -rows 1 -out $file$TILE2.tif
	done
	mv $file$TILE1.tif $file.tif
	for tile in ${TILES[@]}; do
		rm -rf *$tile*
	done
done

for file in regul_seg_maj_8 regul_proba_Fusion_Min_100_1000_100_0_100_70_100_200_0_0_0 classif_regul_urbain classif_S2_urbain classif_Fusion_Min classif_Fusion_Bayes ; do
	FILES=""
	for tile in ${TILES[@]}; do
		echo $tile
		gdal_translate -of JPEG -ot Byte $DIR_SAVE/im_$tile/gt/eval/$file/$file-resized.tif $DIR_SAVE/Eval_bin/$file$tile.tif
		FILES="$FILES$file$tile.tif "
	done
	cd $DIR_SAVE/Eval_bin
	for i in {0..4};do
		TILE1=${TILES[@]:$i:1}
		TILE2=${TILES[@]:$i+1:1}
		~/Documents/OTB/OTB-6.0.0-Linux64/bin/otbcli_TileFusion -il $file$TILE1.tif $file$TILE2.tif -cols 2 -rows 1 -out $file$TILE2.tif
	done
	mv $file$TILE1.tif $file.tif
	for tile in ${TILES[@]}; do
		rm -rf *$tile*
	done
done
rm -rf $DIR_SAVE/Eval_bin/*.xml

