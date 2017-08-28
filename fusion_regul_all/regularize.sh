#!bin/bash
# input: Fusion base directory
# perform regularization on: fusino of regularization 1 and S2 

lambda=1000 	# divisé par  100
gamma=30		# divisé par  100
epsilon=500		# divisé par  100
option_modele=0
option_lissage=0
option_multiplicatif=0

# create directory
BASEDIR=$1/Regul_Fusion
cd $BASEDIR
rm -Rf Regul
mkdir -p Regul

# regularize
converge=0 # check if regularization converged
COUNTER=0
while [ $converge -eq 0 ]
do
	for FUSION_PROB in "Fusion/proba_Fusion_Min"; do
		cd $BASEDIR
		FUSION_NAME=${FUSION_PROB##*/}
		IM_HR=$1/Im_S2.tif # regularization image
		
		~/DeveloppementBase/qpbo_classif_fusion_net/build/Regul ${FUSION_PROB}.tif ${FUSION_PROB}.tif $IM_HR $BASEDIR/Regul/regul_$FUSION_NAME $lambda 0 $gamma $epsilon 5 5 $option_modele $option_lissage $option_multiplicatif
		# visualization
		FILENAME=regul_$FUSION_NAME\_100_$lambda\_100_0_100\_$gamma\_100\_$epsilon\_$option_modele\_$option_lissage\_$option_multiplicatif
		NEWFILENAME=regul_${FUSION_NAME##proba_Fusion_}\_l$lambda\_g$gamma\_e$epsilon\_$option_modele\_$option_lissage\_$option_multiplicatif
		mv Regul/$FILENAME.tif Regul/$NEWFILENAME.tif
		FILENAME=$NEWFILENAME
	
		~/DeveloppementBase/exes/Legende label2RVB ~/DeveloppementBase/Scripts/legende.txt Regul/$FILENAME.tif Regul/$FILENAME.visu.tif
		COUNTER=$((COUNTER + 1))
		echo "Iteration $COUNTER ($(basename $1))"
		cp ${FUSION_PROB}.tfw Regul/$FILENAME.visu.tfw
	done
	converge=$(bash ~/DeveloppementBase/Scripts/gdalminmax.sh $1)
	echo "Converged: $converge"
done
