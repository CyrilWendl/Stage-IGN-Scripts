# Main script to use for fusion, regularization and evaluation
# Difference wrt /Scrits: work only in RAM, then export images
# time bash ~/DeveloppementBase/Scripts/all_tiles/master.sh ${TILES[@]} appart_rf_50000_L93 redo 
# output: classif_min, classif_regul, classif_SPOT6, classif_S2

# work in RAM
RAMDIR="/home/cyrilwendl/Documents/tmp"
sudo umount $RAMDIR # allocate RAM memory
rm -Rf $RAMDIR
mkdir $RAMDIR
sudo mount -t tmpfs -o size=4g tmpfs $RAMDIR # allocate RAM memory

#clear # clear terminal
bold=$(tput bold)
normal=$(tput sgr0)
BASH_PATH=~/DeveloppementBase/Scripts/all_tiles
FUSION_DIR=/media/cyrilwendl/15BA65E227EC1B23/fusion

cd $FUSION_DIR

TILE_S2=${@: -2:1}
echo $TILE_S2
for TILE_SPOT6 in ${@:1:$#-2}; do
	rm -Rf $RAMDIR/*
	echo "${bold}I. FUSION PREPARATION${normal}"
	echo $TILE_SPOT6
	bash $BASH_PATH/fusion_prep.sh $TILE_SPOT6 $TILE_S2 redo # extract probabilities from SPOT6, crop S2 and move both to target directory $3=redo, $4=crop, $5, $6, $7, $8 = x y dx dy		
	
	
	echo ""; echo "${bold}II. COPY IMAGES ${normal}"
	bash $BASH_PATH/copy_images_prep.sh $TILE_SPOT6
	bash $BASH_PATH/copy_images.sh $TILE_SPOT6
	
	echo ""; echo "${bold}III. FUSION${normal}"
	bash $BASH_PATH/fusion.sh 4 $TILE_SPOT6 # Fusion (all weighted)
	
	echo ""; echo "${bold}V. CLASSIFICATION ${normal}"
	bash $BASH_PATH/classify.sh $TILE_SPOT6 weighted # Classify fusion probabilities

	echo ""; echo "${bold}VI. REGULARIZATION ${normal}" 
	
	bash $BASH_PATH/regularize.sh $TILE_SPOT6 # Regularize
	rm -Rf $FUSION_DIR/im_$TILE_SPOT6/
	mkdir $FUSION_DIR/im_$TILE_SPOT6/

	for filename in Classified/classif_SPOT6 Classified/classif_S2 Fusion_all_weighted/classif_Fusion_Min_weighted Regul/regul_Min_weighted_G2_l1000_g70_e500_0_0_0; do
		cp $RAMDIR/im_$TILE_SPOT6/$filename.visu.tif $FUSION_DIR/im_$TILE_SPOT6/$(basename $filename).visu.tif
		cp $RAMDIR/im_$TILE_SPOT6/$filename.visu.tfw $FUSION_DIR/im_$TILE_SPOT6/$(basename $filename).visu.tfw
	done
	
	# regul proba
	cp $RAMDIR/im_$TILE_SPOT6/Regul/regul_Min_weighted_G2_l1000_g70_e500_0_0_0.rle $FUSION_DIR/im_$TILE_SPOT6/regul_Min_weighted_G2_l1000_g70_e500_0_0_0.rle
	# Sentinel2 proba
	cp $RAMDIR/im_$TILE_SPOT6/proba_S2.tif $FUSION_DIR/im_$TILE_SPOT6/proba_S2.tif
	
	# Sentinel2, SPOT6 image
	for im in Im_SPOT6 Im_S2; do
		cp $RAMDIR/im_$TILE_SPOT6/$im.tif $FUSION_DIR/im_$TILE_SPOT6/$im.tif
		cp $RAMDIR/im_$TILE_SPOT6/$im.tfw $FUSION_DIR/im_$TILE_SPOT6/$im.tfw
	done
	
	rm -Rf $RAMDIR/*
	#bash ~/DeveloppementBase/Scripts/fusion_regul_all/master.sh $TILE_SPOT6 $TILE_S2
done

# unmount and empty RAM directory
sudo umount -l $RAMDIR
rm -rf $RAMDIR
