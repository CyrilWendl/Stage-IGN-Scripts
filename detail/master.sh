## Main script to use for fusion, regularization and evaluation
# to be called as: sh master.sh [TILE_SPOT6] ([redo]) ([crop window])
# tiles finistere: 41000_30000 39000_40000 39000_42000 41000_40000 41000_42000
# tiles gironde  : 24500_18500 26500_18500 24500_20500 26500_20500 28500_32500 30500_30500

# Global variables
# Input
export REGION=$1 # command line
export TILE_SPOT6=$2
export TILE_S2=appart_rf_50000_L93 # name of S2

# Paths
export DIR_BASH=~/DeveloppementBase/Scripts/detail # TODO change to where you save the scripts 
export DIR_DATA=/media/cyrilwendl/15BA65E227EC1B23/$REGION/data # TODO change to where you have your data

export DIR_SAVE=$DIR_DATA/../detail/im_$TILE_SPOT6 # target directory to save S2 and SPOT6 probabilities of tile
export DIR_BASH_TOOLS=$DIR_BASH/../tools # tools directory
export DIR_EXES=$DIR_BASH/../exes # Executables directory
export DIR_RAM=$DIR_SAVE/tmp # Temporary directory for work in RAM

# Data
export DIR_PROBA_SPOT6=$DIR_DATA/SPOT6_$REGION/proba/test_$TILE_SPOT6/classification_results/preds # probability SPOT6
export DIR_PROBA_S2=$DIR_DATA/S2_$REGION # probability S2
export DIR_GT=$DIR_DATA/GT/BDTOPO # Grond truth directory

if [ $REGION = "finistere" ]; then
	export DIR_IM_S2=$DIR_DATA/S2_$REGION/20170525 # image S2
	export DEPT=029 # Grond truth: department for RPG
elif [ $REGION = "gironde" ]; then
	export DIR_IM_S2=$DIR_DATA/S2_$REGION/20170618 # image S2
	export DEPT=033 # Grond truth: department for RPG
fi

export IM_SPOT6=/media/cyrilwendl/15BA65E227EC1B23/$REGION/data/SPOT6_$REGION/image/tile_$TILE_SPOT6.tif # image SPOT6 (for reference)

export bold=$(tput bold)
export normal=$(tput sgr0)

echo "${bold}I. FUSION PREPARATION${normal}"
bash $DIR_BASH/fusion_prep.sh $3 $4 $5 $6 $7 $8 $9 # [redo] [crop] [x y dx dy]

echo ""; echo "${bold}II. COPY IMAGES ${normal}"
bash $DIR_BASH/copy_images.sh $4 $5 $6 $7 $8 # [crop] [x y dx dy]

echo ""; echo "${bold}III. GROUND TRUTH ${normal}" 
bash $DIR_BASH/rasterisation_gt.sh

echo ""; echo "${bold}IV. FUSION${normal}"
bash $DIR_BASH/fusion.sh # Fusion

echo ""; echo "${bold}V. CLASSIFICATION ${normal}"
bash $DIR_BASH/classify.sh # Classify fusion probabilities

echo ""; echo "${bold}VI. CLASSIFICATION FUSION ${normal}"
for METHODE in rf svmt2 svmt0; do bash $DIR_BASH/fusion_classification.sh $METHODE; done

echo ""; echo "${bold}VII. REGULARIZATION ${normal}"
if [ "$4" = "crop" ]; then
	bash $DIR_BASH/regularize-crop.sh # Regularize
else
	bash $DIR_BASH/regularize.sh svmt2 # Regularize
	bash $DIR_BASH/regularize.sh Min_weighted # Regularize
fi

echo ""; echo "${bold}VIII. EVALUATION ${normal}" 
bash $DIR_BASH/eval.sh AA FBat # params (d) (AA) (OA) (Fmoy) (K)

echo ""; echo "${bold}IX. URBAN FOOTPRINT ${normal}" 
bash $DIR_BASH/../detail_binary/master.sh $REGION $TILE_SPOT6

echo ""; echo "${bold}X. BINARY GROUND TRUTH ${normal}" 
bash $DIR_BASH/../detail_binary/gt_master.sh $REGION $TILE_SPOT6

#bash $DIR_BASH/binary.sh $TILE_SPOT6
#bash $DIR_BASH/eval_bin.sh $TILE_SPOT6 AA bat
