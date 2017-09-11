#!/usr/bin/env bash

cd $DIR_SAVE

mkdir -p Seg # temporary directory to save files
cd Seg
rm -Rf *

# Labels regul
REGUL_FUSION=../Regul/regul_proba_Fusion_Min_100_1000_100_0_100_70_100_200_0_0_0.tif

# Image S2
Ech_noif ReetalQuantile ../../Im_S2.tif 1 1 Im_S2.tif

# build pyramid and segmentation
echo "ACTION pyramide-and-cut
IMAGEFILE Im_S2.tif
VERBOSE 4" >> param_pyram.txt

seg_cuts=(3 8 15 20 30)

for seg_cut in ${seg_cuts[@]};do
	# create cuts
	echo "CUTS $seg_cut test-$seg_cut.tif" >> param_pyram.txt
done
pyram param_pyram.txt

for seg_cut in ${seg_cuts[@]};do
	# majority voting (labels of regulation within segmentation)
	Pleiades VoteRegion maj test-$seg_cut.tif $REGUL_FUSION regul_seg_maj_$seg_cut.tif
	# create visu.tif
	$DIR_EXES/Legende label2RVB $DIR_SAVE/legende.txt regul_seg_maj_$seg_cut.tif regul_seg_maj_$seg_cut.visu.tif;
done

cp $REGUL_FUSION regul.tif
