# Main script to use for fusion, regularization and evaluation
# Difference wrt /Scrits: work only in RAM, then export images
# time bash ~/DeveloppementBase/Scripts/all_tiles/master.sh ${TILES[@]} appart_rf_50000_L93
# output: classif_min, classif_regul, classif_SPOT6, classif_S2

# global variables
# input
export REGION=gironde
export TILE_S2=${@: -1:1}

export DIR_BASH=~/DeveloppementBase/Scripts/all_tiles # Script directory (where master.sh is located)
export DIR_EXES=~/DeveloppementBase/Scripts/exes # Executables directory
export DIR_RAM=/home/cyrilwendl/Documents/tmp # Temporary directory for work in RAM
export DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/all/tiles

# data
export DIR_DATA=/media/cyrilwendl/15BA65E227EC1B23/$REGION/data
export bold=$(tput bold)
export normal=$(tput sgr0)
#rm -Rf $DIR_SAVE
mkdir -p $DIR_SAVE

# allocate RAM memory
sudo umount -l $DIR_RAM 
rm -Rf $DIR_RAM
mkdir $DIR_RAM
sudo mount -t tmpfs -o size=4g tmpfs $DIR_RAM # allocate RAM memory

cd $DIR_SAVE

for TILE_SPOT6 in ${@:1:$#-1}; do
	# global variables
	export DIR_PROBA_SPOT6=$DIR_DATA/SPOT6_$REGION/proba/test_$TILE_SPOT6/classification_results/preds # probability SPOT6
	export DIR_PROBA_S2=$DIR_DATA/S2_$REGION # probability S2
DNAME="$DIR_RAM/im_$TILE_SPOT6" # target directory
	export TILE_SPOT6=$TILE_SPOT6
	export TILE_S2=$TILE_S2
	export DIR_IM_S2=$DIR_DATA/S2_$REGION/20170419 # image S2
	export IM_SPOT6=/media/cyrilwendl/15BA65E227EC1B23/$REGION/data/SPOT6_$REGION/image/tile_$TILE_SPOT6.tif # image SPOT6 (for reference) 

	# do fusion
	rm -Rf $DIR_RAM/*
	echo "${bold}I. FUSION PREPARATION${normal}"
	echo $TILE_SPOT6
	bash $DIR_BASH/fusion_prep.sh # extract probabilities from SPOT6 and S2, move both to target directory
	
ec	echo ""; echo "${bold}II. COPY IMAGES ${normal}"
	bash $DIR_BASH/copy_images_prep.sh $TILE_SPOT6
	bash $DIR_BASH/copy_images.sh $TILE_SPOT6

	echo ""; echo "${bold}III. FUSION${normal}"
	bash $DIR_BASH/fusion.sh 4 $TILE_SPOT6 # Fusion (all weighted)
	
	echo ""; echo "${bold}V. CLASSIFICATION ${normal}"
	bash $DIR_BASH/classify.sh $TILE_SPOT6 weighted # Classify fusion probabilities

	echo ""; echo "${bold}VI. REGULARIZATION ${normal}" 
	
	timeout 120s bash $DIR_BASH/regularize.sh $TILE_SPOT6 # Regularize
	rm -Rf $DIR_SAVE/im_$TILE_SPOT6/
	mkdir -p $DIR_SAVE/im_$TILE_SPOT6/

	for filename in Classified/classif_SPOT6 Classified/classif_S2 Fusion_all_weighted/classif_Fusion_Min_weighted Regul/regul_Min_weighted_G2_l1000_g70_e500_0_0_0; do
		cp $DIR_RAM/im_$TILE_SPOT6/$filename.visu.tif $DIR_SAVE/im_$TILE_SPOT6/$(basename $filename).visu.tif
		cp $DIR_RAM/im_$TILE_SPOT6/$filename.visu.tfw $DIR_SAVE/im_$TILE_SPOT6/$(basename $filename).visu.tfw
	done
	
	# regul proba
	cp $DIR_RAM/im_$TILE_SPOT6/Regul/regul_Min_weighted_G2_l1000_g70_e500_0_0_0.rle $DIR_SAVE/im_$TILE_SPOT6/regul_Min_weighted_G2_l1000_g70_e500_0_0_0.rle
	# Sentinel2 proba
	cp $DIR_RAM/im_$TILE_SPOT6/proba_S2.tif $DIR_SAVE/im_$TILE_SPOT6/proba_S2.tif
	
	# Sentinel2, SPOT6 image
	for im in Im_SPOT6 Im_S2; do
		cp $DIR_RAM/im_$TILE_SPOT6/$im.tif $DIR_SAVE/im_$TILE_SPOT6/$im.tif
		cp $DIR_RAM/im_$TILE_SPOT6/$im.tfw $DIR_SAVE/im_$TILE_SPOT6/$im.tfw
	done
	
	rm -Rf $DIR_RAM/*
	#bash ~/DeveloppementBase/Scripts/fusion_regul_all/master.sh $TILE_SPOT6 $TILE_S2
done

# unmount and empty RAM directory
sudo umount -l $DIR_RAM
rm -rf $DIR_RAM
