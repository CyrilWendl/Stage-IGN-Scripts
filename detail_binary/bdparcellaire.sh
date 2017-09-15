TILE_SPOT6=38500_32500
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
DIR_EXES=~/DeveloppementBase/Scripts/exes # Executables directory
DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/gironde/detail/im_$TILE_SPOT6
DATA=/media/cyrilwendl/15BA65E227EC1B23/data/bdparcelaire/dpsg2017-08-00247/BDPARCELLAIRE/1_DONNEES_LIVRAISON_2017-08-00247/BDPV_1-2_SHP_LAMB93_D033/PARCELLE.SHP
EMPRISE=$DIR_SAVE/emprise.ori

subfolder=bdparcellaire
rm -Rf $DIR_SAVE/$subfolder
mkdir -p $DIR_SAVE/$subfolder
cd $DIR_SAVE/$subfolder

## proba preparation
# bati
$DIR_EXES/Legende label2masqueunique $DIR_BASH/tools/legende.txt  ../Regul/regul_Min_weighted_G2_l1000_g70_e500_0_0_0.rle 1 bati.tif # binary classification
# dilate
$DIR_EXES/Ech_noif Chamfrein bati.tif dist.tif
$DIR_EXES/Pleiades PriorProb:f:c dist.tif 0 1 200 0 proba_regul_urbain.tif
cp $DIR_SAVE/Regul/regul_Min_weighted_G2_l1000_g70_e500_0_0_0.tfw  proba_regul_urbain.tfw
rm -rf bati.tif dist.tif
# classify
$DIR_EXES/Pleiades Classer proba_regul_urbain.tif classif_regul_urbain.tif

## bdparcellaire
# rasteriser fichier
$DIR_EXES/ManipVecteur LectureGenerale $DATA $EMPRISE bdparcellaire.tif
# vote majoritaire
$DIR_EXES/Pleiades VoteRegion maj bdparcellaire.tif classif_regul_urbain.tif bdparcellaire-vote.tif
# create visu.tif
$DIR_EXES/Legende label2RVB $DIR_BASH/tools/legende.txt bdparcellaire-vote.tif bdparcellaire-vote.visu.tif

cp proba_regul_urbain.tfw bdparcellaire-vote.visu.tfw
