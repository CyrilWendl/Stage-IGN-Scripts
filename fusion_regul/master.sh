# Main script to use for fusion, regularization and evaluation

bold=$(tput bold)
normal=$(tput sgr0)

#global variables
export REGION=$1
export TILE_SPOT6=$2 # from command line

export DIR_BASH=~/DeveloppementBase/Scripts/fusion_regul
export DIR_BASH_TOOLS=~/DeveloppementBase/Scripts/tools # tools directory
export DIR_EXES=~/DeveloppementBase/Scripts/exes # Executables directory
export DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6 # target directory to save S2 and SPOT6 probabilities of tile



echo "${bold}I. FUSION PREPARATION${normal}"
bash $DIR_BASH/fusion_prep.sh 2 # create input probabilities

echo ""; echo "${bold}II. FUSION${normal}"
bash $DIR_BASH/fusion.sh

echo ""; echo "${bold}III. CLASSIFICATION ${normal}"
bash $DIR_BASH/classify.sh # Classify fusion probabilities

# Fusion par classification (in Terminal)
#for method in rf svmt2 svt0; do bash ~/DeveloppementBase/Scripts/fusion_classification.sh $TILE_SPOT6 method; done
 
echo ""; echo "${bold}IV. REGULARIZATION ${normal}"
bash $DIR_BASH/regularize.sh # Regularize

echo ""; echo "${bold}IV. SEGMENTATION ${normal}"
bash $DIR_BASH/segmentation.sh # Regularize
