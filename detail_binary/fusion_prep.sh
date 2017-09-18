CASE=$1

# Proba preparation
# extraire bati
$DIR_EXES/Legende label2masqueunique $DIR_BASH/tools/legende.txt $DIR_IN/Regul/regul_svmt2_G2_l1000_g70_e500_0_0_0.rle 1 bati.tif # get binary mask of regulation (buildings)

# dilater
$DIR_EXES/Ech_noif Chamfrein bati.tif dist.tif
$DIR_EXES/Pleiades PriorProb:f:c dist.tif 0 1 200 0 proba_regul_urbain.tif
mkdir -p Temp
mv bati.tif Temp
mv dist.tif Temp

###
# Test: probabilité moyenne
# 1. extract building probabilities from SVM t2 classification
gdal_translate -b 1 ../Fusion_all_weighted/proba_Fusion_svmt2.tif Temp/proba_svmt2_cl1.tif
# 2. erode buildings
cd Temp
Pleiades Erosion bati.tif 2 bati_erod.tif
# 3. calculate probability
Pleiades PriorProbFromAmorces bati.tif proba_svmt2_cl1.tif proba_regul_urban_mean.tif

Pleiades PriorProbFromAmorces bati_erod.tif proba_svmt2_cl1.tif proba_regul_urban_mean_erod.tif
###
cd ..

# SENTINEL2
rm -rf *tmp*
if [ "$CASE" = 1 ]; then # case 1: P(U) = P(b), P(¬U) = 1 - P(b)
	$DIR_EXES/Bandes $DIR_IN/proba_S2.tif $DIR_SAVE/proba_S2_urbain.tif 1
elif [ "$CASE" = 2 ]; then # case 2: P(U) = P(b) + P(r)
	$DIR_EXES/Bandes $DIR_IN/proba_S2.tif $DIR_SAVE/proba_S2_urbain.tif 2 
fi

for file in proba_S2_urbain proba_regul_urbain; do
	cp ../Im_S2.tfw $file.tfw
	bash $DIR_BASH/tools/raster_resize.sh $file.tif ../Im_S2.tif $file-resized.tif
	mv $file.tif Temp
	mv $file-resized.tif $file.tif
	listgeo $file.tif -tfw
done
