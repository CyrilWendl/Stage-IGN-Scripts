# Main script to use for fusion, regularization and evaluation
# to be called as: sh master.sh [tile_SPOT6] [tile_S2] ([redo]) ([crop window])
# time for TILE in 41000_30000 39000_40000 39000_42000 41000_40000 41000_42000 ; do time bash ~/DeveloppementBase/Scripts/master.sh ${TILE} appart_rf_50000_L93 redo ; done

bold=$(tput bold)
normal=$(tput sgr0)

BASHDIR=~/DeveloppementBase/Scripts/fusion_regul_SPOT6

cd ~/fusion

TILE_SPOT6=$1
TILE_S2=$2

echo "${bold}I. FUSION PREPARATION${normal}"
bash $BASHDIR/fusion_prep.sh $TILE_SPOT6 1 # create input probabilities

echo ""; echo "${bold}II. FUSION${normal}"
bash $BASHDIR/fusion.sh $TILE_SPOT6

echo ""; echo "${bold}III. CLASSIFICATION ${normal}"
bash $BASHDIR/classify.sh $TILE_SPOT6 # Classify fusion probabilities

echo ""; echo "${bold}IV. REGULARIZATION ${normal}"
bash $BASHDIR/regularize-split.sh $TILE_SPOT6 # Regularize
