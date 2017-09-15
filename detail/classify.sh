#!bin/bash

# classify original probabilities (SPOT6, S2)
echo "Target directory: "$DIR_SAVE
cd $DIR_SAVE

rm -rf ./Classified
mkdir ./Classified
cd ./Classified

for methode in "S2" "SPOT6";do
	$DIR_EXES/Pleiades Classer ../proba_$methode.tif classif_$methode.rle
	$DIR_EXES/Legende label2RVB $DIR_BASH/tools/legende.txt classif_$methode.rle classif_$methode.visu.tif	
	cp ../proba_SPOT6.tfw classif_$methode.visu.tfw
done

# copy the "all" case of SPOT6 for automatic import to QGIS
mv classif_SPOT6.rle classif_SPOT6_all.rle
mv classif_SPOT6.visu.tif classif_SPOT6_all.visu.tif
mv classif_SPOT6.visu.tfw classif_SPOT6_all.visu.tfw

mv classif_S2.rle classif_S2_all.rle
mv classif_S2.visu.tif classif_S2_all.visu.tif
mv classif_S2.visu.tfw classif_S2_all.visu.tfw

rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh # parallelize

# classify fusion 
for DNAME in "$DIR_SAVE/Fusion_all" "$DIR_SAVE/Fusion_all_weighted";do
 # target directory 
	echo "Target directory: "$DNAME
	echo -n "cd $DNAME;" >> bashtmp.sh
		
	echo -n "rm -Rf ./Classified;" >> bashtmp.sh
	echo -n "mkdir ./Classified;" >> bashtmp.sh
	echo -n "cd ./Classified;" >> bashtmp.sh

	for i in $DNAME/*.tif ; do
		methode=${i%.tif}
		methode=${methode##*/proba_Fusion_}
		echo -n "$DIR_EXES/Pleiades Classer $DNAME/proba_Fusion_$methode.tif $DNAME/Classified/classif_Fusion_$methode.rle; " >> bashtmp.sh
		echo -n "$DIR_EXES/Legende label2RVB $DIR_BASH/tools/legende.txt $DNAME/Classified/classif_Fusion_$methode.rle $DNAME/Classified/classif_Fusion_$methode.visu.tif; ">> bashtmp.sh
		echo "cp $DNAME/../proba_SPOT6.tfw $DNAME/Classified/classif_Fusion_$methode.visu.tfw" >> bashtmp.sh
	done 
done

$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 16
rm makefiletmp bashtmp.sh

echo "Classification done"
