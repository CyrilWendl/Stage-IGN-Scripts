# bash ~/DeveloppementBase/Scripts/detail/eval_all_zones.sh [region] [tile1] [tile1] [tile1] [tile1] [tile1] [arguments]
# tiles finistere: 41000_30000 39000_40000 39000_42000 41000_40000 41000_42000
# tiles gironde  : 24500_18500 26500_18500 24500_20500 26500_20500 28500_32500 30500_30500
REGION=$1
DIR_BASH=~/DeveloppementBase/Scripts # Script directory (where master.sh is located)
DIR_EXES=$DIR_BASH/exes # Executables directory
DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail # target directory to save S2 and
TILES=${@:2:6} # TODO change argument positions for tiles
echo "Tiles: $TILES"
bold=$(tput bold)
normal=$(tput sgr0)
cd $DIR_SAVE

rm -Rf Eval_all
mkdir Eval_all

FNAME=$DIR_SAVE/Eval_all/eval_all.txt
rm -rf $FNAME

echo "Methode Kappa OA AA Fmoy F_bat" >> $FNAME

# 1. METHOD LOOP
cd $DIR_SAVE/im_$2
rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh

# convert rf, svm, svmt0 and GT to 5cl labels
BASE=Fusion_all_weighted/Classified/classif_Fusion_
for a in $TILES; do # LOOP input arguments 2-6
	cd $DIR_SAVE/im_$a
	for file in train_tout ${BASE}rf ${BASE}svmt0 ${BASE}svmt2 Regul/regul_svmt2_G2_l1000_g70_e500_0_0_0; do
		Ech_noif Format $file.rle $file.tif # create tif for gdal_calc.py
		gdal_calc.py -A $file.tif --calc="A*(A<6)" --outfile="${file}_5cl.tif" # convert class 6 -> class 0
		rm $file.tif # create tif for gdal_calc.py
		Ech_noif Format ${file}_5cl.tif $file.rle # create tif for gdal_calc.py # convert back (overwrite) rle
	done
done

for CLASSIFICATION_DIR in Classified Fusion_all/Classified Fusion_all_weighted/Classified Regul ; do 
	for i in $CLASSIFICATION_DIR/*.rle ; do
		CLASSIF_NAME=${i%.rle}
		CLASSIF_NAME=${CLASSIF_NAME##*/}
		echo $CLASSIF_NAME
		echo -n "echo -n \"${CLASSIF_NAME##classif_Fusion_} \" >> $FNAME;" >> bashtmp.sh
		# 2. TILES LOOP (get addresses for one method)
		M_GT=""
		for a in $TILES; do # LOOP 5 first input arguments
			GT="$DIR_SAVE/im_$a/train_tout.rle"
			M="$DIR_SAVE/im_$a/$CLASSIFICATION_DIR/$CLASSIF_NAME.rle"
			M_GT="$M_GT$M $GT "
		done
		echo "$DIR_EXES/Eval $M_GT $DIR_BASH/tools/legende.txt $DIR_SAVE/Eval_all/cf_$CLASSIF_NAME.txt --Kappa --OA --AA --FScore_moy --FScore_classe 1 >> $FNAME " >> bashtmp.sh
	done
done

$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
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
