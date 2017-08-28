#!bin/bash

if [ $# -ne 1 ]
  then
    return "Exactly one  argument expected: tile number"
fi

BASEDIR="/home/cyrilwendl/fusion/im_$1/Regul_Fusion"

lambda=1000		# divisé par  100
gamma=70		# divisé par  100
epsilon=500		# divisé par  100
option_modele=0
option_lissage=0
option_multiplicatif=0

# create directory
cd $BASEDIR
rm -rf ./Regul; mkdir -p ./Regul

# regularize
for FUSION_PROB in "Fusion/proba_Fusion_Min"; do
	cd $BASEDIR
	FUSION_NAME=${FUSION_PROB##*/}
	IM_HR=/home/cyrilwendl/fusion/im_$1/Im_SPOT6.tif # regularization image
	echo "~/DeveloppementBase/qpbo_classif_fusion_net/build/Regul ${FUSION_PROB}.tif ${FUSION_PROB}.tif $IM_HR $BASEDIR/Regul/regul_$FUSION_NAME $lambda 0 $gamma $epsilon 5 5 $option_modele $option_lissage $option_multiplicatif"
	
	~/DeveloppementBase/qpbo_classif_fusion_net/build/Regul ${FUSION_PROB}.tif ${FUSION_PROB}.tif $IM_HR $BASEDIR/Regul/regul_$FUSION_NAME $lambda 0 $gamma $epsilon 5 5 $option_modele $option_lissage $option_multiplicatif
	# visualization
	FILENAME=regul_$FUSION_NAME\_100_$lambda\_100_0_100\_$gamma\_100\_$epsilon\_$option_modele\_$option_lissage\_$option_multiplicatif
	~/DeveloppementBase/exes/Legende label2RVB ../legende.txt Regul/$FILENAME.tif Regul/$FILENAME.visu.tif
	cp ${FUSION_PROB}.tfw Regul/$FILENAME.visu.tfw
done
