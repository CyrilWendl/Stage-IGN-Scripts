#!/usr/bin/env bash
CASE=$1

rm -Rf $DIR_SAVE
mkdir -p $DIR_SAVE
cd $DIR_SAVE

# Proba preparation
# extraire bati
$DIR_EXES/Legende label2masqueunique $DIR_BASH/legende.txt $DIR_IN/Regul/regul_svmt2_G2_l1000_g70_e500_0_0_0.rle 1 bati.tif # get binary mask of regulation (buildings)

# dilater
#Ech_noif Gaussf bati.tif bati_gauss_10.tif 10 3  # autre alternative?
$DIR_EXES/Ech_noif Chamfrein bati.tif dist.tif
$DIR_EXES/Pleiades PriorProb:f:c dist.tif 0 1 200 0 proba_regul_urbain.tif
mkdir -p Temp
mv bati.tif Temp
mv dist.tif Temp

# SENTINEL2
# case 1: P(U) = P(b), P(¬U) = 1 - P(b)
if [ "$CASE" = 1 ]; then # URBAIN
	$DIR_EXES/Bandes $DIR_IN/proba_S2.tif $DIR_SAVE/proba_S2_urbain.tif 1
elif [ "$CASE" = 2 ]; then # ARTIFICIALISE
	# case 2: P(U) = P(b) + P(r)
	#rm -rf *tmp*
	$DIR_EXES/Bandes $DIR_IN/proba_S2.tif $DIR_SAVE/proba_S2_urbain.tif 2 
fi

for file in proba_S2_urbain proba_regul_urbain; do
	cp ../Im_S2.tfw $file.tfw
	bash $DIR_BASH_TOOLS/raster_resize.sh $file.tif ../Im_S2.tif $file-resized.tif
	mv $file.tif Temp
	mv $file-resized.tif $file.tif
	listgeo $file.tif -tfw
done
