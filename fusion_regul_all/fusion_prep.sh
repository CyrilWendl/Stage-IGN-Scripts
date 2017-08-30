cd $DIR_IN
rm -rf $DIR_OUT
mkdir -p $DIR_OUT

# Proba preparation
# Bati
Legende label2masqueunique $DIR_BASH/legende.txt  regul_Min_weighted_G2_l1000_g70_e500_0_0_0.rle 1 bati.tif # get binary mask of regulation (buildings)

#Ech_noif Gaussf bati.tif bati_gauss_10.tif 10 3  # autre alternative?
Ech_noif Chamfrein bati.tif dist.tif

Pleiades PriorProb:f:c dist.tif 0 1 200 0 $DIR_OUT/proba_regul_urbain.tif
rm -rf bati.tif dist.tif

# SENTINEL2
CASE=$1
# case 1: P(U) = P(b), P(¬U) = 1 - P(b)
# TODO replace with gdal_calc
if [ "$CASE" = 1 ]; then # URBAIN
	$DIR_EXES/Bandes $DIR_IN/proba_S2.tif $DIR_OUT/proba_S2_urbain.tif 1
elif [ "$CASE" = 2 ]; then # ARTIFICIALISE
	# case 2: P(U) = P(b) + P(r)
	$DIR_EXES/Bandes $DIR_IN/proba_S2.tif $DIR_OUT/proba_S2_urbain.tif 2 # TODO check if code is up to date
fi
# TODO consider other variant: if P(r)>P(b)>P(any other class), take P(r) and if P(b)>P(r)>P(any other class), take P(b)

cd $DIR_OUT
for file in proba_S2_urbain proba_regul_urbain; do
	cp ../Im_S2.tfw $file.tfw
	bash $DIR_BASH/raster_resize.sh $file.tif ../Im_S2.tif $file-resized.tif
	mv $file-resized.tif $file.tif
	listgeo $file.tif -tfw
done
