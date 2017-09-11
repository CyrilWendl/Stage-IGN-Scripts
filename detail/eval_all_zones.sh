#bash ~/DeveloppementBase/Scripts/eval_all_zones.sh 41000_30000 39000_40000 39000_42000 41000_40000 41000_42000

DIR_BASH=~/DeveloppementBase/Scripts # Script directory (where master.sh is located)
DIR_EXES=$DIR_BASH/exes # Executables directory

bold=$(tput bold)
normal=$(tput sgr0)
cd ~/fusion/im_$1

rm -Rf ../Eval_all
mkdir ../Eval_all


FNAME=~/fusion/Eval_all/eval_all.txt
rm -rf $FNAME

GT_BASE="train_tout.rle"
LEGENDE=~/DeveloppementBase/Scripts/legende.txt

echo "Methode Kappa OA AA Fmoy F_bat" >> $FNAME

# 1. METHOD LOOP
rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh
for CLASSIFICATION_DIR in Classified ./Fusion_all_weighted/Classified ./Fusion_all/Classified Regul ; do 
	for i in $CLASSIFICATION_DIR/*.rle ; do
		CLASSIF_NAME=${i%.rle}
		CLASSIF_NAME=${CLASSIF_NAME##*/}
		echo -n "echo -n \"${CLASSIF_NAME##classif_Fusion_} \" >> $FNAME;" >> bashtmp.sh
		#echo -n "$CLASSIFICATION_DIR  $CLASSIF_NAME" >> $FNAME

		# Loop through all images (excluding the start image) and get the names of the corresponding 
		# 2. TILES LOOP (get addresses for one method)
		#M_GT="" # variable to save method addresses, each time followed by ground truth address
		M_GT=""
		for a in "${@:1:5}" # LOOP 5 first input arguments
		do
			GT="~/fusion/im_$a/$GT_BASE"
			M="~/fusion/im_$a/$CLASSIFICATION_DIR/$CLASSIF_NAME.rle"
			M_GT="$M_GT$M $GT "
		done
		echo "~/DeveloppementBase/exes/Eval $M_GT $LEGENDE ~/fusion/Eval_all/cf_$CLASSIF_NAME.txt --Kappa --OA --AA --FScore_moy --FScore_classe 1 >> $FNAME " >> bashtmp.sh
		#~/DeveloppementBase/exes/Eval $M_GT $LEGENDE ~/fusion/Eval_all/cf_$CLASSIF_NAME.txt --Kappa --OA --AA --FScore_moy --FScore_classe 1 >> $FNAME
	done
done

~/DeveloppementBase/exes/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 1
rm makefiletmp bashtmp.sh

for a in "$@"
do
    if [ "$a" = "K" ]; then
		echo "${bold}Sorted by Kappa:${normal}"
		cat $FNAME|  sort -k2 -r | column -s ' '  -t
	elif [ "$a" = "OA" ]; then
		echo "${bold}Sorted by OA:${normal}"
		cat $FNAME|  sort -k3 -r | column -s ' '  -t
	elif [ "$a" = "AA" ]; then
		echo "${bold}Sorted by AA:${normal}"
		cat $FNAME|  sort -k4 -r | column -s ' '  -t
	elif [ "$a" = "Fmoy" ]; then
		echo "${bold}Sorted by Fmoy:${normal}"
		cat $FNAME|  sort -k5 -r | column -s ' '  -t
	elif [ "$a" = "Fbat" ]; then
		echo "${bold}Sorted by F_Bat:${normal}"
		cat $FNAME|  sort -k6 -r | column -s ' '  -t
	fi
done
