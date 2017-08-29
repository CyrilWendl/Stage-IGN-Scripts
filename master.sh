# Main script to use for fusion, regularization and evalueation
# to be called as: sh master.sh [TILE_SPOT6] [TILE_S2] ([redo]) ([crop window])
# 	e.g.		   sh master.sh 41000_40000 appart_rf_50000_L93 redo
# time for TILE in 41000_30000 39000_40000 39000_42000 41000_40000 41000_42000; do time bash ~/DeveloppementBase/Scripts/master.sh ${TILE} appart_rf_50000_L93 redo ; done																																								
# gironde: 38500_32500									


# Global variables
# Input
export REGION=$1
export TILE_SPOT6=$2 # from command line
export TILE_S2=$3 # from command line

# Paths
export DIR_BASH=~/DeveloppementBase/Scripts # Script directory (where master.sh is located)
export DIR_EXES=~/DeveloppementBase/exes # Executables directory
export DIR_RAM=/home/cyrilwendl/Documents/tmp # Temporary directory for work in RAM
export DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6 # target directory to save S2 and SPOT6 probabilities of tile

# Data
export DIR_DATA=/media/cyrilwendl/15BA65E227EC1B23/$REGION/data
export DIR_PROBA_SPOT6=$DIR_DATA/SPOT6_$REGION/proba/test_$TILE_SPOT6/classification_results/preds # probability SPOT6
export DIR_PROBA_S2=$DIR_DATA/S2_$REGION # probability S2
export DIR_GT=$DIR_DATA/GT/BDTOPO # Grond truth directory
export DIR_IM_S2=$DIR_DATA/S2_$REGION/20170419 # image S2

export IM_SPOT6=/media/cyrilwendl/15BA65E227EC1B23/$REGION/data/SPOT6_$REGION/image/tile_$TILE_SPOT6.tif # image SPOT6 (for reference)


bold=$(tput bold)
normal=$(tput sgr0)

# extract probabilities from SPOT6, crop S2 and move both to target directory
echo "${bold}I. FUSION PREPARATION${normal}"
bash $DIR_BASH/fusion_prep.sh $4 $5 $6 $7 $8 $9 # $3=redo, $4=crop, $5, $6, $7, $8 = x y dx dy

echo ""; echo "${bold}II. COPY IMAGES ${normal}"
if [ "$4" = "crop" ]; then
	bash $DIR_BASH/copy_images.sh crop $6 $7 $8 $9 # Copy orinal probabilities (HDD: ~35s, RAM:  ~15s)
else
	bash $DIR_BASH/copy_images.sh  # Copy orinal probabilities (HDD: ~35s, RAM:  ~15s)
fi

echo ""; echo "${bold}III. GROUND TRUTH ${normal}" 
bash $DIR_BASH/rasterisation_gt.sh


echo ""; echo "${bold}IV. FUSION${normal}"
bash $DIR_BASH/fusion.sh 3 # Fusion (all)
bash $DIR_BASH/fusion.sh 4 # Fusion (all weighted)


echo ""; echo "${bold}V. CLASSIFICATION ${normal}"
bash $DIR_BASH/classify.sh # Classify fusion probabilities

# Fusion par classification (after model calculated)
# bash $DIR_BASH/fusion_classification-model.sh # classification model
# for method in rf svmt2 svmt0; do bash $DIR_BASH/fusion_classification.sh $methode; done
 
echo ""; echo "${bold}VI. REGULARIZATION ${normal}"
if [ "$4" = "crop" ]; then
	bash $DIR_BASH/regularize-test.sh # Regularize
else
	bash $DIR_BASH/regularize.sh # Regularize
fi

echo ""; echo "${bold}VII. EVALUATION ${normal}" 
bash $DIR_BASH/eval.sh AA bat # params (d) (AA) (OA) (Fmoy) (K)

echo ""; echo "${bold}VIII. URBAN FOOTPRINT ${normal}" 
bash $DIR_BASH/fusion_regul/master.sh $REGION $TILE_SPOT6 # TODO adapt to new data structure
#bash $DIR_BASH/binary.sh $TILE_SPOT6
#bash $DIR_BASH/eval_bin.sh $TILE_SPOT6 AA bat
