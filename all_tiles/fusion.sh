bold=$(tput bold)
normal=$(tput sgr0)

# input files
P1NAME="proba_SPOT6.tif"
P2NAME="proba_S2.tif"

cd $DIR_RAM/im_$TILE_SPOT6

echo "${bold}Bands preparation${normal}"
CASE=$1
WEIGHTED=""

# weighted probabilities
$DIR_EXES/FusProb PointWise $DIR_RAM/im_$TILE_SPOT6/proba_SPOT6.tif $DIR_RAM/im_$TILE_SPOT6/proba_S2.tif $DIR_RAM/proba_SPOT6_weighted$TILE_SPOT6.tif $DIR_RAM/proba_S2_weighted$TILE_SPOT6.tif
cp $DIR_RAM/im_$TILE_SPOT6/proba_SPOT6.tfw $DIR_RAM/proba_SPOT6_weighted$TILE_SPOT6.tfw
cp $DIR_RAM/im_$TILE_SPOT6/proba_S2.tfw $DIR_RAM/proba_S2_weighted$TILE_SPOT6.tfw
P1NAME="$DIR_RAM/proba_SPOT6_weighted$TILE_SPOT6.tif"
P2NAME="$DIR_RAM/proba_S2_weighted$TILE_SPOT6.tif"
OUTDIR="$DIR_RAM/im_$TILE_SPOT6/Fusion_all_weighted"
WEIGHTED="_weighted"

echo "${bold}Prepare directories${normal}"
mkdir $OUTDIR
cd $OUTDIR
pwd

echo "${bold}Fusion${normal}"

#TODO SVMt2 fusion over entire zone
$DIR_EXES/FusProb Fusion:Min $P1NAME $P2NAME $OUTDIR/proba_Fusion_Min$WEIGHTED.tif
cp $DIR_RAM/im_$TILE_SPOT6/proba_SPOT6.tfw $OUTDIR/proba_Fusion_Min$WEIGHTED.tfw

# Classification
$DIR_EXES/Pleiades Classer $OUTDIR/proba_Fusion_Min$WEIGHTED.tif $DIR_RAM/classif_Fusion_Min$WEIGHTED$TILE_SPOT6.rle;
$DIR_EXES/Legende label2RVB $DIR_RAM/im_$TILE_SPOT6/tools/legende.txt $DIR_RAM/classif_Fusion_Min$WEIGHTED$TILE_SPOT6.rle $OUTDIR/classif_Fusion_Min$WEIGHTED.visu.tif
cp $DIR_RAM/im_$TILE_SPOT6/proba_SPOT6.tfw $OUTDIR/classif_Fusion_Min$WEIGHTED.visu.tfw
rm $DIR_RAM/*$TILE_SPOT6*

