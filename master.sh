# Main script to use for fusion, regularization and evalueation
# to be called as: sh master.sh [TILE_SPOT6] [TILE_S2] ([redo]) ([crop window])
# 	e.g.		   sh master.sh 41000_40000 appart_rf_50000_L93 redo
# time for TILE in 41000_30000 39000_40000 39000_42000 41000_40000 41000_42000; do time bash ~/DeveloppementBase/Scripts/master.sh ${TILE} appart_rf_50000_L93 redo ; done																																																	

# Global variables
# Paths
export DIR_BASH=~/DeveloppementBase/Scripts # Script directory (where master.sh is located)
export DIR_EXES=~/DeveloppementBase/exes # Executables directory
export DIR_RAM=/home/cyrilwendl/Documents/tmp # Temporary directory for work in RAM
export DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/detail/im_$1 # target directory to save probability
# Data
export DIR_PROBA_SPOT6=/home/cyrilwendl/finistere1/test_$1/classification_results/preds # probability SPOT6
export DIR_PROBA_S2=/media/cyrilwendl/Data/Images_S2_finistere # probability S2
export DIR_GT=/media/cyrilwendl/Data/VeriteTerrain/BDTOPO_2-1_TOUSTHEMES_SHP_LAMB93_D029_2015-03-26/BDTOPO/1_DONNEES_LIVRAISON_2015-04-00253/BDT_2-1_SHP_LAMB93_D029-ED151 # Grond truth directory
export DIR_IM_S2=/media/cyrilwendl/Data/Images_S2_finistere/20170525 # image S2
export IM_SPOT6=/media/cyrilwendl/Data/Images_SPOT6_finistere/tile_$1.tif # image SPOT6 (for reference)
export TILE_SPOT6=$1 # from command line
export TILE_S2=$2 # from command line

bold=$(tput bold)
normal=$(tput sgr0)

# extract probabilities from SPOT6, crop S2 and move both to target directory
echo "${bold}I. FUSION PREPARATION${normal}"
bash $DIR_BASH/fusion_prep.sh $3 $4 $5 $6 $7 $8 # $3=redo, $4=crop, $5, $6, $7, $8 = x y dx dy


echo ""; echo "${bold}II. COPY IMAGES ${normal}"
if [ "$4" = "crop" ]; then
	bash $DIR_BASH/copy_images.sh crop $5 $6 $7 $8 # Copy orinal probabilities (HDD: ~35s, RAM:  ~15s)
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
bash $DIR_BASH/fusion_regul/master.sh $TILE_SPOT6
#bash $DIR_BASH/binary.sh $TILE_SPOT6
#bash $DIR_BASH/eval_bin.sh $TILE_SPOT6 AA bat
