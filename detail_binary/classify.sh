# classify original probabilities (SPOT6, S2)
cd $DIR_SAVE

rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh # parallelize: bash file with commands

# classify fusion 
for DNAME in "$DIR_SAVE" "$DIR_SAVE/Fusion";do 
 # target directory 
	echo "Target directory: "$DNAME
	echo -n "cd $DNAME;" >> bashtmp.sh
		
	echo -n "rm -Rf ./Classified;" >> bashtmp.sh
	echo -n "mkdir ./Classified;" >> bashtmp.sh
	echo -n "cd ./Classified;" >> bashtmp.sh

	for i in $DNAME/*.tif ; do
		methode=${i%.tif}
		methode=${methode##*/proba_}
		echo -n "$DIR_EXES/Pleiades Classer $i $DNAME/Classified/classif_$methode.rle; " >> bashtmp.sh
		echo -n "$DIR_EXES/Legende label2RVB $DIR_BASH/tools/legende_agg_bin.txt $DNAME/Classified/classif_$methode.rle $DNAME/Classified/classif_$methode.visu.tif; ">> bashtmp.sh
		echo "cp $DIR_SAVE/proba_S2_urbain.tfw $DNAME/Classified/classif_$methode.visu.tfw" >> bashtmp.sh
	done 
done

$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 1
rm makefiletmp bashtmp.sh

echo "Classification done"
