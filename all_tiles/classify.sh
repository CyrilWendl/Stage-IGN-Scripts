# classify original probabilities (SPOT6, S2)
echo "Target directory: "$DIR_RAM
cd $DIR_RAM/im_$1

rm -rf ./Classified
mkdir ./Classified
cd ./Classified

for methode in "S2" "SPOT6";do
	~/DeveloppementBase/exes/Pleiades Classer ../proba_$methode.tif classif_$methode.rle
	~/DeveloppementBase/exes/Legende label2RVB ../legende.txt classif_$methode.rle classif_$methode.visu.tif	
	cp ../proba_SPOT6.tfw classif_$methode.visu.tfw
	rm classif_$methode.rle # free RAM
done
