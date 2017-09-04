TILE_SPOT6=38500_32500
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
DIR_EXES=~/DeveloppementBase/Scripts/exes # Executables directory
DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/gironde/detail/im_$TILE_SPOT6
DATA=/media/cyrilwendl/15BA65E227EC1B23/data/bdparcelaire/dpsg2017-08-00247/BDPARCELLAIRE/1_DONNEES_LIVRAISON_2017-08-00247/BDPV_1-2_SHP_LAMB93_D033/PARCELLE.SHP
EMPRISE=$DIR_SAVE/emprise.ori
VOTER=$DIR_SAVE/Regul/regul_proba_Fusion_Min_100_1000_100_0_100_70_100_200_0_0_0.tif

cd $DIR_SAVE
# rasteriser fichier
ManipVecteur LectureGenerale $DATA $EMPRISE $DIR_SAVE/bdparcellaire.rle

# vote majoritaire
# majority voting (labels of regulation within segmentation)
$DIR_EXES/Pleiades VoteRegion maj bdparcellaire.tif $VOTER bdparcellaire-vote.tif
# create visu.tif
$DIR_EXES/Legende label2RVB $DIR_BASH/legende.txt bdparcellaire-vote.tif bdparcellaire-vote.visu.tif;
