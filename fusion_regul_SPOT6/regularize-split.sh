#!bin/bash

if [ $# -ne 1 ]
  then
    return "Exactly one  argument expected: tile number"
fi

BASEDIR="/home/cyrilwendl/fusion/im_$1/Regul_Fusion"

lambda=1000		# divisé par  100
gamma=90		# divisé par  100
epsilon=500		# divisé par  100
option_modele=0
option_lissage=0
option_multiplicatif=0

# create directory
cd $BASEDIR/..


# lissage gaussien
SIGMA=20;GAUSS="_G$SIGMA"
~/DeveloppementBase/exes/Ech_noif Gaussf Im_SPOT6.tif Im_SPOT6_G$SIGMA.tif $SIGMA 3
cp Im_SPOT6.tfw Im_SPOT6_G$SIGMA.tfw

cd $BASEDIR
rm -Rf ./Regul; mkdir -p ./Regul

# split rasters
rm -rf *crop* Fusion_all_weighted/*crop*

vals=($(seq 0 1000 2069))
len=${#vals[@]}
vals[$len-1]=2069
let len=$len-1

rm -rf  makefiletmp bashtmp.sh
touch bashtmp.sh # parallelize
for FUSION_PROB in "../Im_SPOT6_G$SIGMA" "Fusion/proba_Fusion_Min"; do
	echo "Splitting $FUSION_PROB"
	for (( i=0; i<len;i++ )); do
		for (( j=0; j<len;j++ )); do
			x=${vals[$i]} 
			y=${vals[$j]}
			diff_x=$(expr ${vals[$i+1]} - ${vals[$i]})
			diff_y=$(expr ${vals[$j+1]} - ${vals[$j]})
			echo $x $y $diff_x $diff_y
			echo -n "gdal_translate -srcwin $x $y $diff_x $diff_y $FUSION_PROB.tif $FUSION_PROB\_crop_${x}_${y}.tif;" >> bashtmp.sh
			echo "listgeo ${FUSION_PROB}_crop_${x}_${y}.tif -tfw" >> bashtmp.sh
		done
	done
done
~/DeveloppementBase/exes/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 16
rm makefiletmp bashtmp.sh

# regularize
for FUSION_PROB in "Fusion/proba_Fusion_Min"; do
	cd $BASEDIR
	FUSION_NAME=${FUSION_PROB##*/}
	rm -rf makefiletmp bashtmp.sh
	touch bashtmp.sh # parallelize
	FILENAMES_CROP=""
	FILENAMES_CROP_VISU=""
	for (( i=0; i<len;i++ )); do
		for (( j=0; j<len;j++ )); do
			x=${vals[$i]} 
			y=${vals[$j]}
			CROP="crop_${x}_${y}"
			#regularize
			IM_HR=/home/cyrilwendl/fusion/im_$1/Im_SPOT6_G${SIGMA}_$CROP.tif # HR image
			echo -n "~/DeveloppementBase/qpbo_classif_fusion_net/build/Regul ${FUSION_PROB}_$CROP.tif ${FUSION_PROB}_$CROP.tif $IM_HR $BASEDIR/Regul/regul_$FUSION_NAME$CROP $lambda 0 $gamma $epsilon 5 5 $option_modele $option_lissage $option_multiplicatif; " >> bashtmp.sh
			# visualization
			FILENAME=regul_$FUSION_NAME$CROP\_100_$lambda\_100_0_100\_$gamma\_100\_$epsilon\_$option_modele\_$option_lissage\_$option_multiplicatif
			echo -n "~/DeveloppementBase/exes/Legende label2RVB ../legende.txt Regul/$FILENAME.tif Regul/$FILENAME.visu.tif;" >> bashtmp.sh
			echo -n "cp ${FUSION_PROB}_$CROP.tfw Regul/${FILENAME}.tfw ; " >> bashtmp.sh
			echo "cp ${FUSION_PROB}_$CROP.tfw Regul/${FILENAME}.visu.tfw " >> bashtmp.sh
			FILENAMES_CROP=$FILENAMES_CROP$FILENAME".tif "
			FILENAMES_CROP_VISU=$FILENAMES_CROP_VISU$FILENAME".visu.tif "
		done
	done	
	echo $FILENAMES_CROP
	echo $FILENAMES_CROP_VISU
	~/DeveloppementBase/exes/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
	make -f makefiletmp -j 16
	rm makefiletmp bashtmp.sh
	
	# merge regularization result and visualization
	cd $BASEDIR/Regul
	FILENAME_REASSEMBLED=regul_${FUSION_NAME##proba_Fusion_}$GAUSS\_l$lambda\_g$gamma\_e$epsilon\_$option_modele\_$option_lissage\_$option_multiplicatif
	rm -rf $FILENAME_REASSEMBLED.tif
	echo "gdal_merge.py -of GTiff -o $FILENAME_REASSEMBLED.tif $FILENAMES_CROP"  # regularization
	gdal_merge.py -of GTiff -o $FILENAME_REASSEMBLED.tif $FILENAMES_CROP  # regularization
	~/DeveloppementBase/exes/Ech_noif Format $FILENAME_REASSEMBLED.tif $FILENAME_REASSEMBLED.rle  # RLE for Eval
	cp ../../Im_SPOT6.tfw $FILENAME_REASSEMBLED.tfw 
	gdal_merge.py -of GTiff -o $FILENAME_REASSEMBLED.visu.tif $FILENAMES_CROP_VISU  # visualization
	cp ../Im_SPOT6.tfw $FILENAME_REASSEMBLED.visu.tfw 
	rm -rf *crop*
done

rm -rf *crop* ../*crop* ../Fusion_all_weighted/*crop*
