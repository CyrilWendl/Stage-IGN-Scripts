# Main script to use for fusion, regularization and evaluation
# to be called as: sh master.sh [region] [tile_SPOT6]

# global variables
# input
export REGION=$1
export TILE_SPOT6=$2
export TILE_S2=appart_rf_50000_L93

# data directories
export DIR_FUSION=/media/cyrilwendl/15BA65E227EC1B23/gironde/all/tiles
export DIR_EXES=~/DeveloppementBase/Scripts/exes # Executables directory
export DIR_IN=$DIR_FUSION/im_$TILE_SPOT6
export DIR_OUT=$DIR_FUSION/im_$TILE_SPOT6/Regul_Fusion

export DIR_BASH=~/DeveloppementBase/Scripts

export bold=$(tput bold)
export normal=$(tput sgr0)



cd ~/fusion/$REGO


echo "TILE SPOT6: $TILE_SPOT6"
echo "${bold}I. FUSION PREPARATION${normal}"
bash $DIR_BASH/fusion_regul_all/fusion_prep.sh 1 # create input probabilities
exit
echo ""; echo "${bold}II. FUSION${normal}"
bash $DIR_BASH/fusion_regul_all/fusion.sh

echo ""; echo "${bold}III. CLASSIFICATION ${normal}"
bash $DIR_BASH/fusion_regul_all/classify.sh  # Classify fusion probabilities

echo ""; echo "${bold}IV. REGULARIZATION ${normal}"
#bash $DIR_BASH/fusion_regul_all/regularize.sh $FUSION_DIR # Regularize
