bold=$(tput bold)
normal=$(tput sgr0)

DIR="$2/Regul_Fusion"
cd $DIR
mkdir -p ./Fusion
cd ./Fusion

P1NAME="$DIR/proba_regul_urbain.tif" 
P2NAME="$DIR/proba_S2_urbain.tif"

~/DeveloppementBase/exes/FusProb Fusion:Min $P1NAME $P2NAME proba_Fusion_Min$WEIGHTED.tif
~/DeveloppementBase/exes/FusProb Fusion:Bayes $P1NAME $P2NAME proba_Fusion_Bayes$WEIGHTED.tif

for methode in Min Bayes;do
  cp ../proba_S2_urbain.tfw proba_Fusion_$methode.tfw
done
