#!bin/bash
BASEDIR=$DIR_SAVE/Regul_Fusion

lambda=1000		# divisé par  100
gamma=70		# divisé par  100
epsilon=200		# divisé par  100
option_modele=0
option_lissage=0
option_multiplicatif=0

# create directory
cd $BASEDIR
rm -rf ./Regul; mkdir -p ./Regul

# regularize
converge=0 # check if regularization converged
while [ $converge -eq 0 ]
do
	for FUSION_PROB in "Fusion/proba_Fusion_Min"; do
		cd $BASEDIR
		FUSION_NAME=${FUSION_PROB##*/}
		IM_HR=$DIR_SAVE/Im_S2.tif # regularization image
		$DIR_EXES/Regul ${FUSION_PROB}.tif ${FUSION_PROB}.tif $IM_HR $BASEDIR/Regul/regul_$FUSION_NAME $lambda 0 $gamma $epsilon 5 5 $option_modele $option_lissage $option_multiplicatif
		
		# visualization
		FILENAME=regul_$FUSION_NAME\_100_$lambda\_100_0_100\_$gamma\_100\_$epsilon\_$option_modele\_$option_lissage\_$option_multiplicatif
		$DIR_EXES/Legende label2RVB ../legende.txt Regul/$FILENAME.tif Regul/$FILENAME.visu.tif
		cp ${FUSION_PROB}.tfw Regul/$FILENAME.visu.tfw
	done
	converge=$(bash $DIR_BASH_TOOLS/gdalminmax.sh $DIR_SAVE)
	echo "Converged: $converge"
done
