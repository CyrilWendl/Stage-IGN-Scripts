bold=$(tput bold)
normal=$(tput sgr0)

# input files
P1NAME="proba_SPOT6.tif"
P2NAME="proba_S2.tif"

cd $DIR_RAM/im_$TILE_SPOT6

echo "${bold}Bands preparation${normal}"
CASE=$1
WEIGHTED=""
# case 1: P(U) = P(b), P(¬U) = 1 - P(b)
if [ "$CASE" = 1 ]; then # URBAIN
	echo "${bold}Case 1: buildings (bat)${normal}"
	~/DeveloppementBase/ExempleCode_souche/build/Exemple $DIR_RAM/im_$TILE_SPOT6/$P1NAME $DIR_RAM/im_$TILE_SPOT6/proba_SPOT6_bat.tif 1
	~/DeveloppementBase/ExempleCode_souche/build/Exemple $DIR_RAM/im_$TILE_SPOT6/$P2NAME $DIR_RAM/im_$TILE_SPOT6/proba_S2_bat.tif 1
	P1NAME="../proba_SPOT6_bat.tif"
	P2NAME="../proba_S2_bat.tif"
	OUTDIR="./Fusion_bat"
elif [ "$CASE" = 2 ]; then # ARTIFICIALISE
	# case 2: P(U) = P(b) + P(r)
	echo "${bold}Case 2: artificial (art)${normal}"
	~/DeveloppementBase/ExempleCode_souche/build/Exemple $DIR_RAM/im_$TILE_SPOT6/$P1NAME $DIR_RAM/im_$TILE_SPOT6/proba_SPOT6_art.tif 2
	~/DeveloppementBase/ExempleCode_souche/build/Exemple $DIR_RAM/im_$TILE_SPOT6/$P2NAME $DIR_RAM/im_$TILE_SPOT6/proba_S2_art.tif 2
	P1NAME="../proba_SPOT6_art.tif"
	P2NAME="../proba_S2_art.tif"
	OUTDIR="./Fusion_art"
elif [ "$CASE" = 3 ]; then # ALL
	echo "${bold}Case 3: all bands (all)${normal}"
	# sh ~/DeveloppementBase/Scripts/copy_bands.sh $TILE_SPOT6 (for different number of tiles)
	P1NAME="../proba_SPOT6.tif"
	P2NAME="../proba_S2.tif"
	OUTDIR="./Fusion_all"
elif [ "$CASE" = 4 ]; then # ALL (WEIGHTED)
	echo "${bold}Case 4: all bands weighted (all_weighted)${normal}"
	# weighted probabilities
	$DIR_EXES/FusProb PointWise $DIR_RAM/im_$TILE_SPOT6/proba_SPOT6.tif $DIR_RAM/im_$TILE_SPOT6/proba_S2.tif $DIR_RAM/proba_SPOT6_weighted$TILE_SPOT6.tif $DIR_RAM/proba_S2_weighted$TILE_SPOT6.tif
	cp $DIR_RAM/im_$TILE_SPOT6/proba_SPOT6.tfw $DIR_RAM/proba_SPOT6_weighted$TILE_SPOT6.tfw
	cp $DIR_RAM/im_$TILE_SPOT6/proba_S2.tfw $DIR_RAM/proba_S2_weighted$TILE_SPOT6.tfw
	P1NAME="$DIR_RAM/proba_SPOT6_weighted$TILE_SPOT6.tif"
	P2NAME="$DIR_RAM/proba_S2_weighted$TILE_SPOT6.tif"
	OUTDIR="$DIR_RAM/im_$TILE_SPOT6/Fusion_all_weighted"
	WEIGHTED="_weighted"
fi

echo "${bold}Prepare directories${normal}"
mkdir $OUTDIR
cd $OUTDIR
pwd

echo "${bold}Fusion${normal}"

$DIR_EXES/FusProb Fusion:Min $P1NAME $P2NAME $OUTDIR/proba_Fusion_Min$WEIGHTED.tif
cp $DIR_RAM/im_$TILE_SPOT6/proba_SPOT6.tfw $OUTDIR/proba_Fusion_Min$WEIGHTED.tfw

# Classification
$DIR_EXES/Pleiades Classer $OUTDIR/proba_Fusion_Min$WEIGHTED.tif $DIR_RAM/classif_Fusion_Min$WEIGHTED$TILE_SPOT6.rle;
$DIR_EXES/Legende label2RVB $DIR_RAM/im_$TILE_SPOT6/legende.txt $DIR_RAM/classif_Fusion_Min$WEIGHTED$TILE_SPOT6.rle $OUTDIR/classif_Fusion_Min$WEIGHTED.visu.tif
cp $DIR_RAM/im_$TILE_SPOT6/proba_SPOT6.tfw $OUTDIR/classif_Fusion_Min$WEIGHTED.visu.tfw
rm $DIR_RAM/*$TILE_SPOT6*

