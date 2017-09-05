# Fusion by classification
METHODE=$1

cd /media/cyrilwendl/15BA65E227EC1B23/$REGION/detail

$DIR_EXES/Classifieur Classify -d classification.model.path=./fusion_classif/model_$METHODE -d canaux.path=im_$TILE_SPOT6/proba_S2.tif,im_$TILE_SPOT6/proba_SPOT6.tif -d classification.output.path=im_$TILE_SPOT6/Fusion_all_weighted/Classified/classif_Fusion_$METHODE.rle -d global.verbose=true -d classification.output.proba.path=im_$TILE_SPOT6/Fusion_all_weighted/proba_Fusion_$METHODE.tif -d classification.save.proba=true;
cp im_$TILE_SPOT6/proba_SPOT6.tfw im_$TILE_SPOT6/Fusion_all_weighted/proba_Fusion_$METHODE.tfw ;

#visualisation
$DIR_EXES/Legende label2RVB $DIR_BASH/../legende_gt_6cl.txt im_$TILE_SPOT6/Fusion_all_weighted/Classified/classif_Fusion_$METHODE.rle im_$TILE_SPOT6/Fusion_all_weighted/Classified/classif_Fusion_$METHODE.visu.tif ;
cp im_$TILE_SPOT6/proba_SPOT6.tfw im_$TILE_SPOT6/Fusion_all_weighted/Classified/classif_Fusion_$METHODE.visu.tfw ;
