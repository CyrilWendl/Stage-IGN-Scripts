# input: tile number 

if [ $# -lt 1 ] 
  then
    return "At least one  argument expected: tile number" 
fi
RAMDIR="/home/cyrilwendl/Documents/tmp/"
BDIR="/media/cyrilwendl/15BA65E227EC1B23/fusion/im_$1"

# classify original probabilities (SPOT6, S2)
echo "Target directory: "$RAMDIR
cd $RAMDIR/im_$1

rm -rf ./Classified
mkdir ./Classified
cd ./Classified

for methode in "S2" "SPOT6";do
	~/DeveloppementBase/exes/Pleiades Classer ../proba_$methode.tif classif_$methode.rle
	~/DeveloppementBase/exes/Legende label2RVB ../legende.txt classif_$methode.rle classif_$methode.visu.tif	
	cp ../proba_SPOT6.tfw classif_$methode.visu.tfw
	rm classif_$methode.rle # free RAM
done
