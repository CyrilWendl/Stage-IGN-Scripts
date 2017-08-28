# input: Fusion base directory
BDIR="$1/Regul_Fusion"

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
		~/DeveloppementBase/exes/Pleiades Classer $i $DNAME/Classified/classif_$methode.rle
		~/DeveloppementBase/exes/Legende label2RVB ~/DeveloppementBase/Scripts/legende.txt $DNAME/Classified/classif_$methode.rle $DNAME/Classified/classif_$methode.visu.tif
		cp $BDIR/proba_S2_urbain.tfw $DNAME/Classified/classif_$methode.visu.tfw
	done 
done

echo "Classification done"
