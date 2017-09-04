CASE=$1
cd $DIR_SAVE

echo "Bands preparation"
WEIGHTED=""
if [ "$CASE" = 1 ]; then # ALL
	echo "Case 1: all bands (all)"
	P1NAME="$DIR_SAVE/proba_SPOT6.tif"
	P2NAME="$DIR_SAVE/proba_S2.tif"
	OUTDIR="$DIR_SAVE/Fusion_all"
elif [ "$CASE" = 2 ]; then # ALL (WEIGHTED)
	echo "Case 2: all bands weighted (all_weighted)"
	$DIR_EXES/FusProb PointWise proba_SPOT6.tif proba_S2.tif proba_SPOT6_weighted.tif proba_S2_weighted.tif
	cp proba_SPOT6.tfw proba_SPOT6_weighted.tfw
	cp proba_S2.tfw proba_S2_weighted.tfw
	P1NAME="$DIR_SAVE/proba_SPOT6_weighted.tif"
	P2NAME="$DIR_SAVE/proba_S2_weighted.tif"
	OUTDIR="$DIR_SAVE/Fusion_all_weighted"
	WEIGHTED="_weighted"
fi

echo "Prepare directories"
rm -rf $OUTDIR
mkdir $OUTDIR
cd $OUTDIR
pwd

echo "Fusion"
touch bashtmp.sh # parallelize

echo "$DIR_EXES/FusProb Fusion:Min $P1NAME $P2NAME proba_Fusion_Min$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Max $P1NAME $P2NAME proba_Fusion_Max$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Compromis $P1NAME $P2NAME proba_Fusion_Compromis$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:CompromisWO $P1NAME $P2NAME proba_Fusion_CompromisWO$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Prior1 $P1NAME $P2NAME proba_Fusion_Prior1$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Prior1 $P2NAME $P1NAME  proba_Fusion_Prior1-inv$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Prior2 $P1NAME $P2NAME proba_Fusion_Prior2$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Prior2 $P2NAME $P1NAME proba_Fusion_Prior2-inv$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Marge:Max $P1NAME $P2NAME proba_Fusion_Marge_Max$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Marge:SommePond $P1NAME $P2NAME proba_Fusion_Marge_SommePond$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Marge:BayesPond $P1NAME $P2NAME proba_Fusion_Marge_BayesPond$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:DS:MasseSomme $P1NAME $P2NAME proba_Fusion_DS_MasseSomme$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:DS:MasseV1 $P1NAME $P2NAME proba_Fusion_DS_MasseV1$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:DS:MasseV2 $P1NAME $P2NAME proba_Fusion_DS_MasseV2$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Moyenne $P1NAME $P2NAME proba_Fusion_Moyenne$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Bayes $P1NAME $P2NAME proba_Fusion_Bayes$WEIGHTED.tif" >> bashtmp.sh

$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 16
rm makefiletmp bashtmp.sh

for methode in Min Max Compromis CompromisWO Prior1 Prior1-inv Prior2 Prior2-inv Marge_Max Marge_SommePond Marge_BayesPond DS_MasseSomme DS_MasseV1 DS_MasseV2 Moyenne Bayes;do
  cp ../proba_SPOT6.tfw proba_Fusion_$methode$WEIGHTED.tfw
done

# remove composite classes
touch bashtmp.sh # parallelize: bash file with commands
for methode in DS_MasseSomme DS_MasseV1 DS_MasseV2;do
	echo -n "gdal_translate -b 1 -b 2 -b 3 -b 4 -b 5 proba_Fusion_$methode$WEIGHTED.tif tmp.tif;" >> bashtmp.sh # keep only 5 first classes 
	echo "mv tmp.tif proba_Fusion_$methode$WEIGHTED.tif" >> bashtmp.sh
done
$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 1
rm makefiletmp bashtmp.sh
