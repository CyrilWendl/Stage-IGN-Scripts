TILE=$1

REGUL_DIR=/media/cyrilwendl/15BA65E227EC1B23/fusion/im_$TILE/Regul_Fusion
cd $REGUL_DIR
 
mkdir -p Seg # temporary directory to save files
cd Seg
rm -Rf *

# Labels regul
REGUL_FUSION=../Regul/regul_Min_l1000_g30_e500_0_0_0.tif

# Image S2
Ech_noif ReetalQuantile ../../Im_S2.tif 1 1 Im_S2.tif
cp ../../Im_S2.tfw Im_S2.tfw

# build pyramid and segmentation
echo "ACTION pyramide-and-cut
IMAGEFILE Im_S2.tif
VERBOSE 4" >> param_pyram.txt

seg_cuts=(3 8 15 20 30 50 70 90)

for seg_cut in ${seg_cuts[@]};do
	# create cuts
	echo "CUTS $seg_cut test-$seg_cut.tif" >> param_pyram.txt
done
pyram param_pyram.txt 

for seg_cut in ${seg_cuts[@]};do
	# majority voting (labels of regulation within segmentation)
	Pleiades VoteRegion maj test-$seg_cut.tif $REGUL_FUSION regul_seg_maj_$seg_cut.tif
	# create visu.tif
	~/DeveloppementBase/exes/Legende label2RVB ~/DeveloppementBase/Scripts/tools/legende.txt regul_seg_maj_$seg_cut.tif regul_seg_maj_$seg_cut.visu.tif;
	cp ../proba_S2_urbain.tfw regul_seg_maj_$seg_cut.visu.tfw
done


#convert regul_seg_maj.tif regul_seg_maj.jpg
cp $REGUL_FUSION regul.tif
