#!/usr/bin/env bash
CASE=$1
INDIR=$DIR_SAVE/Regul
OUTDIR=$DIR_SAVE/Regul_Fusion
cd $INDIR
rm -Rf $OUTDIR
mkdir -p $OUTDIR

# Proba preparation
# extraire bati
$DIR_EXES/Legende label2masqueunique $DIR_BASH/legende.txt  regul_Min_weighted_G2_l1000_g70_e500_0_0_0.rle 1 bati.tif # get binary mask of regulation (buildings)

# dilater
#Ech_noif Gaussf bati.tif bati_gauss_10.tif 10 3  # autre alternative?
$DIR_EXES/Ech_noif Chamfrein bati.tif dist.tif
$DIR_EXES/Pleiades PriorProb:f:c dist.tif 0 1 200 0 $OUTDIR/proba_regul_urbain.tif
#rm -rf bati.tif dist.tif

# SENTINEL2
# case 1: P(U) = P(b), P(¬U) = 1 - P(b)
# TODO replace with gdal_calc
if [ "$CASE" = 1 ]; then # URBAIN
	$DIR_EXES/Bandes $DIR_SAVE/proba_S2.tif $OUTDIR/proba_S2_urbain.tif 1
elif [ "$CASE" = 2 ]; then # ARTIFICIALISE
	# case 2: P(U) = P(b) + P(r)
	#gdal_calc.py -A $DIR_SAVE/proba_S2.tif --A_band=1 -B $DIR_SAVE/proba_S2.tif --B_band=5 --outfile=tmp1.tif --calc="(B+A)"
	#gdal_calc.py -A tmp1.tif --outfile=tmp2.tif --calc="1-A"
	#gdal_merge.py -separate tmp1.tif tmp2.tif -o $OUTDIR/proba_S2_urbain.tif
	#rm -rf *tmp*
	$DIR_EXES/Bandes $DIR_SAVE/proba_S2.tif $OUTDIR/proba_S2_urbain.tif 2 
fi

cd $OUTDIR
for file in proba_S2_urbain proba_regul_urbain; do
	cp ../Im_S2.tfw $file.tfw
	bash $DIR_BASH_TOOLS/raster_resize.sh $file.tif ../Im_S2.tif $file-resized.tif
	mv $file-resized.tif $file.tif
	listgeo $file.tif -tfw
done
