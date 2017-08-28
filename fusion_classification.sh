# Fusion by classification
cd ~/fusion
IMAGE=$1
METHODE=$2

~/DeveloppementBase/exes/Classifieur Classify -d classification.model.path=./fusion_classif/model_$METHODE -d canaux.path=im_$IMAGE/proba_S2.tif,im_$IMAGE/proba_SPOT6.tif -d classification.output.path=im_$IMAGE/Fusion_all_weighted/Classified/classif_Fusion_$METHODE.rle -d global.verbose=true -d classification.output.proba.path=im_$IMAGE/Fusion_all_weighted/proba_Fusion_$METHODE.tif -d classification.save.proba=true;
cp im_$IMAGE/proba_SPOT6.tfw im_$IMAGE/Fusion_all_weighted/proba_Fusion_$METHODE.tfw ;

#visualisation
Legende label2RVB im_$IMAGE/legende.txt im_$IMAGE/Fusion_all_weighted/Classified/classif_Fusion_$METHODE.rle im_$IMAGE/Fusion_all_weighted/Classified/classif_Fusion_$METHODE.visu.tif ;
cp im_$IMAGE/proba_SPOT6.tfw im_$IMAGE/Fusion_all_weighted/Classified/classif_Fusion_$METHODE.visu.tfw ;
