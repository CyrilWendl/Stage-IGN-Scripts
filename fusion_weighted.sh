# creates weighted probabilities and uses them for classification in subfolder /Fusion_all_weighted

cd ~/fusion/im_$1

P1NAME="../proba_SPOT6_weighted.tif"
P2NAME="../proba_S2_weighted.tif"
OUTDIR="./Fusion_all_weighted"

# weighted probabilities
~/DeveloppementBase/exes/FusProb PointWise proba_SPOT6.tif proba_S2.tif proba_SPOT6_weighted.tif proba_S2_weighted.tif
cp proba_SPOT6.tfw proba_SPOT6_weighted.tfw
cp proba_S2.tfw proba_S2_weighted.tfw

rm -rf $OUTDIR

mkdir $OUTDIR
cd $OUTDIR

echo "${bold}Fusion${normal}"
rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh # parallelize: bash file with commands

# new fusion rules
echo "~/DeveloppementBase/exes/FusProb Fusion:Min $P1NAME $P2NAME proba_Fusion_Min.tif" >> bashtmp.sh
echo "~/DeveloppementBase/exes/FusProb Fusion:Max $P1NAME $P2NAME proba_Fusion_Max.tif" >> bashtmp.sh
echo "~/DeveloppementBase/exes/FusProb Fusion:Compromis $P1NAME $P2NAME proba_Fusion_Compromis.tif" >> bashtmp.sh
echo "~/DeveloppementBase/exes/FusProb Fusion:CompromisWO $P1NAME $P2NAME proba_Fusion_CompromisWO.tif" >> bashtmp.sh
echo "~/DeveloppementBase/exes/FusProb Fusion:Prior1 $P1NAME $P2NAME proba_Fusion_Prior1.tif" >> bashtmp.sh
echo "~/DeveloppementBase/exes/FusProb Fusion:Prior2 $P1NAME $P2NAME proba_Fusion_Prior2.tif" >> bashtmp.sh

# old fusion rules (with weighted input)
echo "~/DeveloppementBase/exes/FusProb Fusion:Marge:Max $P1NAME $P2NAME proba_Fusion_Marge_Max.tif" >> bashtmp.sh
echo "~/DeveloppementBase/exes/FusProb Fusion:Marge:SommePond $P1NAME $P2NAME proba_Fusion_Marge_SommePond.tif" >> bashtmp.sh
echo "~/DeveloppementBase/exes/FusProb Fusion:Marge:BayesPond $P1NAME $P2NAME proba_Fusion_Marge_BayesPond.tif" >> bashtmp.sh


echo "~/DeveloppementBase/exes/FusProb Fusion:DS:MasseSomme $P1NAME $P2NAME proba_Fusion_DS_MasseSomme.tif" >> bashtmp.sh
echo "~/DeveloppementBase/exes/FusProb Fusion:DS:MasseV1 $P1NAME $P2NAME proba_Fusion_DS_MasseV1.tif" >> bashtmp.sh
echo "~/DeveloppementBase/exes/FusProb Fusion:DS:MasseV2 $P1NAME $P2NAME proba_Fusion_DS_MasseV2.tif" >> bashtmp.sh

echo "~/DeveloppementBase/exes/FusProb Fusion:Moyenne $P1NAME $P2NAME proba_Fusion_DS_Moyenne.tif" >> bashtmp.sh
echo "~/DeveloppementBase/exes/FusProb Fusion:Bayes $P1NAME $P2NAME proba_Fusion_Bayes.tif" >> bashtmp.sh


~/DeveloppementBase/exes/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 16
rm makefiletmp bashtmp.sh
echo "DONE"

for methode in Marge_Max Marge_SommePond Marge_BayesPond DS_MasseSomme DS_MasseV1 DS_MasseV2;do
  cp ../proba_SPOT6.tfw proba_Fusion_$methode.tfw
done

# Fusion par classification (in Terminal)
#sh ~/DeveloppementBase/Scripts/fusion_classification-model.sh # créer le modèle
#sh ~/DeveloppementBase/Scripts/fusion_classification.sh 35000_40000 rf
#sh ~/DeveloppementBase/Scripts/fusion_classification.sh 35000_40000 svmt2
#sh ~/DeveloppementBase/Scripts/fusion_classification.sh 35000_40000 svmt0
