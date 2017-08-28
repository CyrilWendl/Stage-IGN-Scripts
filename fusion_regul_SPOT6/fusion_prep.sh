#!bin/bash
# Two input probabilities (regul and Sentinel 2)
# Fusion cases
# 1. R: P(B), S: P(B)
# 2. R: P(B), S: P(B)+P(R)
# 3. R: P(B)+P(R), S: P(B)+P(R)
# fusion_regul.sh [tile] [case]
cd

if [ $# -lt 2 ]
  then
    return "At least two arguments expected"
fi

INDIR=~/fusion/im_$1/Regul
OUTDIR=~/fusion/im_$1/Regul_Fusion
cd $INDIR
rm -Rf $OUTDIR
mkdir -p $OUTDIR

# Proba preparation
# Bati
Legende label2masqueunique ../legende.txt  regul_Min_weighted_G2_l1000_g70_e500_0_0_0.rle 1 bati.tif # get binary mask of regulation (buildings)

#Ech_noif Gaussf bati.tif bati_gauss_10.tif 10 3  # autre alternative?
Ech_noif Chamfrein bati.tif dist.tif

Pleiades PriorProb:f:c dist.tif 0 1 200 0 $OUTDIR/proba_regul_urbain.tif

# divide by 255
#gdal_calc.py -A $OUTDIR/proba_regul_urbain.tif --calc="A/255" --outfile=$OUTDIR/proba_regul_urbain_gdal.tif --type=Float32 

#rm bati.tif dist.tif

# SENTINEL2
CASE=$2
# case 1: P(U) = P(b), P(¬U) = 1 - P(b)
if [ "$CASE" = 1 ]; then # URBAIN
	~/DeveloppementBase/ExempleCode_souche/build/Exemple ~/fusion/im_$1/proba_S2.tif $OUTDIR/proba_S2_urbain.tif 1
elif [ "$CASE" = 2 ]; then # ARTIFICIALISE
	# case 2: P(U) = P(b) + P(r)
	~/DeveloppementBase/ExempleCode_souche/build/Exemple ~/fusion/im_$1/proba_S2.tif $OUTDIR/proba_S2_urbain.tif 2 # TODO check if code is up to date
fi
# TODO consider other variant: if P(r)>P(b)>P(any other class), take P(r) and if P(b)>P(r)>P(any other class), take P(b)

cd $OUTDIR
for file in proba_S2_urbain proba_regul_urbain; do
	cp ../Im_S2.tfw $file.tfw
	#bash ~/DeveloppementBase/Scripts/raster-resize.sh $file.tif ../Im_S2.tif $file-resized.tif
	#mv $file-resized.tif $file.tif
	#listgeo $file.tif -tfw
done
