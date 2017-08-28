# Main script to use for fusion, regularization and evaluation
# to be called as: 
# bash ~/DeveloppementBase/Scripts/master.sh [tile_SPOT6] [tile_S2] ([redo]) ([crop window])
# bash ~/DeveloppementBase/Scripts/fusion_regul/master.sh 41000_30000 appart_rf_50000_L93 redo

bold=$(tput bold)
normal=$(tput sgr0)

#global variables
export BASHDIR=~/DeveloppementBase/Scripts/fusion_regul
export DIR_EXES=~/DeveloppementBase/exes # Executables directory
export DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/detail/im_$1 # target directory to save probability
export TILE_SPOT6=$1 # from command line
export TILE_S2=$2 # from command line

echo "${bold}I. FUSION PREPARATION${normal}"
bash $BASHDIR/fusion_prep.sh 2 # create input probabilities

echo ""; echo "${bold}II. FUSION${normal}"
bash $BASHDIR/fusion.sh

echo ""; echo "${bold}III. CLASSIFICATION ${normal}"
bash $BASHDIR/classify.sh # Classify fusion probabilities

# Fusion par classification (in Terminal)
#for method in rf svmt2 svt0; do bash ~/DeveloppementBase/Scripts/fusion_classification.sh $TILE_SPOT6 method; done
 
echo ""; echo "${bold}IV. REGULARIZATION ${normal}"
bash $BASHDIR/regularize.sh # Regularize

echo ""; echo "${bold}IV. SEGMENTATION ${normal}"
bash $BASHDIR/segmentation.sh # Regularize
