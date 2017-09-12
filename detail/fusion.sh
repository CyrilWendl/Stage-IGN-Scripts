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
for method in Min Max Compromis CompromisWO Prior1 Prior2 "Marge:Max" "Marge:SommePond" "Marge:BayesPond" "DS:MasseSomme" "DS:MasseV1" "DS:MasseV2" Moyenne Bayes; do
	savename=$(echo $method|sed 's/:/_/g')
	echo "$DIR_EXES/FusProb Fusion:$method $DIR_SAVE/proba_SPOT6_weighted.tif $DIR_SAVE/proba_S2_weighted.tif $OUTDIR/proba_Fusion_${savename}_weighted.tif" >> bashtmp.sh
done

# original probability
OUTDIR="$DIR_SAVE/Fusion_all"
rm -Rf $OUTDIR
mkdir -p $OUTDIR
for method in Min Max Compromis CompromisWO Prior1 Prior2 "Marge:Max" "Marge:SommePond" "Marge:BayesPond" "DS:MasseSomme" "DS:MasseV1" "DS:MasseV2" Moyenne; do
	savename=$(echo $method|sed 's/:/_/g')
	echo "$DIR_EXES/FusProb Fusion:$method $DIR_SAVE/proba_SPOT6.tif $DIR_SAVE/proba_S2.tif $OUTDIR/proba_Fusion_$savename.tif" >> bashtmp.sh
done

$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 10
rm makefiletmp bashtmp.sh

# copy tfw files
for methode in Min Max Compromis CompromisWO Prior1 Prior1-inv Prior2 Prior2-inv Marge_Max Marge_SommePond Marge_BayesPond DS_MasseSomme DS_MasseV1 DS_MasseV2 Moyenne Bayes;do
  cp ../proba_SPOT6.tfw proba_Fusion_$methode$WEIGHTED.tfw
done

# remove composite classes
for methode in DS_MasseSomme DS_MasseV1 DS_MasseV2;do
	gdal_translate -b 1 -b 2 -b 3 -b 4 -b 5 proba_Fusion_$methode$WEIGHTED.tif tmp.tif # keep only 5 first classes
	mv tmp.tif proba_Fusion_$methode$WEIGHTED.tif
done
