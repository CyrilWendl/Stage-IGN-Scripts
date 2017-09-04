# importing fusion results from Walid's R code

TILE=$1
DEST=~/fusion/im_$TILE/Walid
rm -Rf $DEST $DEST/Classified/
mkdir $DEST $DEST/Classified/

BASEDIR=/home/cyrilwendl/Walid/Codes_propres_fusion/Results_Finistere
cd $BASEDIR

# 1 Prior1_pointwise
# 2 

for i in `seq 1 1 9`; do 
	cd $BASEDIR/Regle$i
	STRING=$(ls $BASEDIR/Regle$i | grep "Legende")
    if [ !  -z  $STRING  ];then
	    cp $STRING $DEST/Classified/$STRING # Legende_... (visu)
    	cp $DEST/../proba_SPOT6.tfw $DEST/Classified/${STRING%.tif}.tfw
    	STRING=${STRING#*_}   # remove prefix ending in "_"
		cp $STRING $DEST/$STRING # Fichier label
	fi
done

for filename in $DEST/*.tif; do
	~/DeveloppementBase/exes/Ech_noif Format $filename ${filename%.tif}.rle # RLE for Eval
done 
