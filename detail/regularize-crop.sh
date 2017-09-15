# Regularization script to test different parameters on a small zone
# methode pour trouver paramètres optimaux :
# - trouver lambda_max [0, infty[ avec un Potts model (gamma=0 et beta=infty OU gamma=1 et eps=0)
# testé: 0 10 50(y) 100 500 1000
# - trouver beta_max [0, infty[ avec lambda_max et gamma=0
# testé: 500 700 1000 1300 s1500(y)
# - Trouver epsilon_max [0, infty[ avec lambda_max, beta_max and gamma=1
# testé: 0 5 10 50 100 500 700 1000 1300 1500 (pas de différence)
# - Trouver gamma max [0, 1]
# testé: 0 20 40 60 80 100 (pas de différence)
# more contrast: more noise but better geometry
# itérer procédure

# meilleurs paramètres pour modèle de contraste 0: l1000 g70 e500
# meilleurs paramètres pour modèle de contraste 3: l750  g96

lambda=1000		# divisé par  100 (fixé)
gamma=70		# divisé par  100
epsilon=500	# divisé par  100
option_modele=0
option_lissage=0
option_multiplicatif=0

# output directory
cd $DIR_SAVE
rm -rf ./Regul
mkdir -p ./Regul

# parallelisation
rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh 

# lissage gaussien
SIGMA=2
$DIR_EXES/Ech_noif Gaussf Im_SPOT6.tif Im_SPOT6_Gauss_$SIGMA.tif $SIGMA 3
cp Im_SPOT6.tfw Im_SPOT6_Gauss_$SIGMA.tfw
GAUSS="_G$SIGMA"

FUSIONDIR="Fusion_all_weighted"
#regularize
for FUSION_PROB in $FUSIONDIR/proba_Fusion_Min_weighted proba_SPOT6 ; do
	FUSION_NAME=${FUSION_PROB##*/}
	echo -n "$DIR_EXES/Regul $FUSION_PROB.tif $FUSION_PROB.tif Im_SPOT6_Gauss_$SIGMA.tif Regul/regul_$FUSION_NAME$GAUSS $lambda 0 $gamma $epsilon 5 5 $option_modele $option_lissage 0; " >> bashtmp.sh
	echo -n "echo regul done ; " >> bashtmp.sh
	# visualization
	FILENAME=regul_$FUSION_NAME$GAUSS\_100_$lambda\_100_0_100\_$gamma\_100\_$epsilon\_$option_modele\_$option_lissage\_0

	FILENAME_NEW=regul_${FUSION_NAME##proba_Fusion_}$GAUSS\_$option_lissage\_l$lambda\_g$gamma\_e$epsilon
	echo -n "mv Regul/$FILENAME.tif Regul/$FILENAME_NEW.tif ; " >> bashtmp.sh
	FILENAME=$FILENAME_NEW
	echo -n "$DIR_EXES/Ech_noif Format Regul/$FILENAME.tif Regul/$FILENAME.rle ; " >> bashtmp.sh # RLE for Eval
	echo -n "$DIR_EXES/Legende label2RVB $DIR_BASH/../tools/legende.txt Regul/$FILENAME.tif Regul/$FILENAME.visu.tif; " >> bashtmp.sh
	echo -n "echo visualisation done ; "  >> bashtmp.sh
	# coordinates
	echo -n "cp $FUSION_PROB.tfw Regul/$FILENAME.tfw; " >> bashtmp.sh
	echo "cp $FUSION_PROB.tfw Regul/$FILENAME.visu.tfw" >> bashtmp.sh
done
$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation 
make -f makefiletmp -j 10
rm makefiletmp bashtmp.sh
