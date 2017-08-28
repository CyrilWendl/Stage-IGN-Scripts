bold=$(tput bold)
normal=$(tput sgr0)

if [ $# -ne 2 ]
  then
    return "Exactly two  arguments expected: case (1, 2 or 3) and tile number"
fi

TILE=$2

# input files
DNAME="/media/cyrilwendl/15BA65E227EC1B23/fusion/im_$TILE" # target directory 
P1NAME="proba_SPOT6.tif"
P2NAME="proba_S2.tif"
RAMDIR="/home/cyrilwendl/Documents/tmp"

cd $RAMDIR/im_$TILE

echo "${bold}Bands preparation${normal}"
CASE=$1
WEIGHTED=""
# case 1: P(U) = P(b), P(¬U) = 1 - P(b)
if [ "$CASE" = 1 ]; then # URBAIN
	echo "${bold}Case 1: buildings (bat)${normal}"
	~/DeveloppementBase/ExempleCode_souche/build/Exemple $RAMDIR/im_$TILE/$P1NAME $RAMDIR/im_$TILE/proba_SPOT6_bat.tif 1
	~/DeveloppementBase/ExempleCode_souche/build/Exemple $RAMDIR/im_$TILE/$P2NAME $RAMDIR/im_$TILE/proba_S2_bat.tif 1
	P1NAME="../proba_SPOT6_bat.tif"
	P2NAME="../proba_S2_bat.tif"
	OUTDIR="./Fusion_bat"
elif [ "$CASE" = 2 ]; then # ARTIFICIALISE
	# case 2: P(U) = P(b) + P(r)
	echo "${bold}Case 2: artificial (art)${normal}"
	~/DeveloppementBase/ExempleCode_souche/build/Exemple $RAMDIR/im_$TILE/$P1NAME $RAMDIR/im_$TILE/proba_SPOT6_art.tif 2
	~/DeveloppementBase/ExempleCode_souche/build/Exemple $RAMDIR/im_$TILE/$P2NAME $RAMDIR/im_$TILE/proba_S2_art.tif 2
	P1NAME="../proba_SPOT6_art.tif"
	P2NAME="../proba_S2_art.tif"
	OUTDIR="./Fusion_art"
elif [ "$CASE" = 3 ]; then # ALL
	echo "${bold}Case 3: all bands (all)${normal}"
	# sh ~/DeveloppementBase/Scripts/copy_bands.sh $TILE (for different number of tiles)
	P1NAME="../proba_SPOT6.tif"
	P2NAME="../proba_S2.tif"
	OUTDIR="./Fusion_all"
elif [ "$CASE" = 4 ]; then # ALL (WEIGHTED)
	echo "${bold}Case 4: all bands weighted (all_weighted)${normal}"
	# weighted probabilities
	~/DeveloppementBase/exes/FusProb PointWise $RAMDIR/im_$TILE/proba_SPOT6.tif $RAMDIR/im_$TILE/proba_S2.tif $RAMDIR/proba_SPOT6_weighted$TILE.tif $RAMDIR/proba_S2_weighted$TILE.tif
	cp $RAMDIR/im_$TILE/proba_SPOT6.tfw $RAMDIR/proba_SPOT6_weighted$TILE.tfw
	cp $RAMDIR/im_$TILE/proba_S2.tfw $RAMDIR/proba_S2_weighted$TILE.tfw
	P1NAME="$RAMDIR/proba_SPOT6_weighted$TILE.tif"
	P2NAME="$RAMDIR/proba_S2_weighted$TILE.tif"
	OUTDIR="$RAMDIR/im_$TILE/Fusion_all_weighted"
	WEIGHTED="_weighted"
fi

echo "${bold}Prepare directories${normal}"
mkdir $OUTDIR
cd $OUTDIR
pwd

echo "${bold}Fusion${normal}"

~/DeveloppementBase/exes/FusProb Fusion:Min $P1NAME $P2NAME $OUTDIR/proba_Fusion_Min$WEIGHTED.tif
cp $RAMDIR/im_$TILE/proba_SPOT6.tfw $OUTDIR/proba_Fusion_Min$WEIGHTED.tfw

# Classification
~/DeveloppementBase/exes/Pleiades Classer $OUTDIR/proba_Fusion_Min$WEIGHTED.tif $RAMDIR/classif_Fusion_Min$WEIGHTED$TILE.rle;
~/DeveloppementBase/exes/Legende label2RVB $RAMDIR/im_$TILE/legende.txt $RAMDIR/classif_Fusion_Min$WEIGHTED$TILE.rle $OUTDIR/classif_Fusion_Min$WEIGHTED.visu.tif
cp $RAMDIR/im_$TILE/proba_SPOT6.tfw $OUTDIR/classif_Fusion_Min$WEIGHTED.visu.tfw
rm $RAMDIR/*$TILE*

