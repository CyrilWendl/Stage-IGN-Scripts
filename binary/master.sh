# Main script to use for fusion, regularization and evaluation

bold=$(tput bold)
normal=$(tput sgr0)

#global variables
export REGION=$1
export TILE_SPOT6=$2 # from command line

export DIR_BASH=~/DeveloppementBase/Scripts/binary
export DIR_BASH_TOOLS=~/DeveloppementBase/Scripts/tools # tools directory
export DIR_EXES=~/DeveloppementBase/Scripts/exes # Executables directory
export DIR_IN=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6
export DIR_SAVE=$DIR_IN/Binary

rm -rf $DIR_SAVE
mkdir -p $DIR_SAVE
cd $DIR_SAVE
exit
echo "${bold}I. FUSION PREPARATION${normal}"
bash $DIR_BASH/fusion_prep.sh 2 # create input probabilities

echo ""; echo "${bold}II. FUSION${normal}"
bash $DIR_BASH/fusion.sh

echo ""; echo "${bold}III. CLASSIFICATION ${normal}"
bash $DIR_BASH/classify.sh # Classify fusion probabilities

echo ""; echo "${bold}IV. REGULARIZATION ${normal}"
bash $DIR_BASH/regularize.sh # Regularize

echo ""; echo "${bold}V. SEGMENTATION ${normal}"
bash $DIR_BASH/segmentation.sh # Regularize
