# input: Fusion base directory
BDIR=$DIR_FUSION/im_$TILE_SPOT6/Regul_Fusion

for DNAME in "$BDIR" "$BDIR/Fusion";do 
	# target directory 
	echo "Target directory: "$DNAME
	cd $DNAME
		
	rm -Rf ./Classified
	mkdir ./Classified
	cd ./Classified

	for i in $DNAME/*.tif ; do
		methode=${i%.tif}
		methode=${methode##*/proba_}
		$DIR_EXES/Pleiades Classer $i $DNAME/Classified/classif_$methode.rle
		$DIR_EXES/Legende label2RVB $DIR_BASH/tools/legende.txt $DNAME/Classified/classif_$methode.rle $DNAME/Classified/classif_$methode.visu.tif
		cp $BDIR/proba_S2_urbain.tfw $DNAME/Classified/classif_$methode.visu.tfw
	done 
done

echo "Classification done"
