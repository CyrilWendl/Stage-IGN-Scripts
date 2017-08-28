bold=$(tput bold)
normal=$(tput sgr0)

DIR=$DIR_SAVE/Regul_Fusion
cd $DIR
mkdir -p ./Fusion
cd ./Fusion
P1NAME="$DIR/proba_regul_urbain.tif" 
P2NAME="$DIR/proba_S2_urbain.tif"

rm -rf bashtmp.sh makefiletmp.sh
touch bashtmp.sh # parallelize
pwd
echo "$DIR_EXES/FusProb Fusion:Min $P1NAME $P2NAME proba_Fusion_Min$WEIGHTED.tif" >> bashtmp.sh
echo "$DIR_EXES/FusProb Fusion:Bayes $P1NAME $P2NAME proba_Fusion_Bayes$WEIGHTED.tif" >> bashtmp.sh

$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 2
rm makefiletmp bashtmp.sh

for methode in Min Bayes;do
  cp ../proba_S2_urbain.tfw proba_Fusion_$methode.tfw
done
