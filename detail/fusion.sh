CASE=$1
cd $DIR_SAVE

# weighted probabilities
$DIR_EXES/FusProb PointWise proba_SPOT6.tif proba_S2.tif proba_SPOT6_weighted.tif proba_S2_weighted.tif
cp proba_SPOT6.tfw proba_SPOT6_weighted.tfw
cp proba_S2.tfw proba_S2_weighted.tfw

# fusion
touch bashtmp.sh # parallelize
rm -rf bashtmp.sh makefiletmp

# weighted
OUTDIR="$DIR_SAVE/Fusion_all_weighted"
rm -Rf $OUTDIR
mkdir -p $OUTDIR
for method in Min Max Compromis CompromisWO Prior1 Prior2; do
	savename=$(echo $method|sed 's/:/_/g')
	echo "$DIR_EXES/FusProb Fusion:$method $DIR_SAVE/proba_SPOT6_weighted.tif $DIR_SAVE/proba_S2_weighted.tif $OUTDIR/proba_Fusion_${savename}_weighted.tif" >> bashtmp.sh
	cp $DIR_SAVE/proba_SPOT6.tfw $OUTDIR/proba_Fusion_${savename}_weighted.tfw
done

# non-weighted
OUTDIR="$DIR_SAVE/Fusion_all"
rm -Rf $OUTDIR
mkdir -p $OUTDIR
for method in Min Max Compromis CompromisWO Prior1 Prior2 "Marge:Max" "Marge:SommePond" "Marge:BayesPond" "DS:MasseSomme" "DS:MasseV1" "DS:MasseV2" Moyenne Bayes; do
	savename=$(echo $method|sed 's/:/_/g')
	echo "$DIR_EXES/FusProb Fusion:$method $DIR_SAVE/proba_SPOT6.tif $DIR_SAVE/proba_S2.tif $OUTDIR/proba_Fusion_$savename.tif" >> bashtmp.sh
	cp $DIR_SAVE/proba_SPOT6.tfw $OUTDIR/proba_Fusion_$savename.tfw
done
$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 16
rm makefiletmp bashtmp.sh

# remove composite classes for DS
for methode in DS_MasseSomme DS_MasseV1 DS_MasseV2;do
	gdal_translate -b 1 -b 2 -b 3 -b 4 -b 5 $OUTDIR/proba_Fusion_$methode.tif $OUTDIR/tmp.tif
	mv $OUTDIR/tmp.tif $OUTDIR/proba_Fusion_$methode.tif
done
