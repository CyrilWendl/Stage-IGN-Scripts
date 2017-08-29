DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts

. $DIR_BASH/param.sh
sudo umount -l $DIR_RAM # allocate RAM memory
rm -Rf $DIR_RAM
mkdir $DIR_RAM
sudo mount -t tmpfs -o size=4g tmpfs $DIR_RAM # allocate RAM memory
# $REGION
cd /media/cyrilwendl/15BA65E227EC1B23/$REGION/data/SPOT6_$REGION/proba
tiles=($(ls | awk '(substr($1, 6, 5) >= 30000) && (substr($1, 12, 5) > 20000) && (substr($1, 6, 5) < 43000)' | awk '{print substr($0,6,11)}' | grep -E '[0-9]{2}[0]{3}'))
# gironde
#tiles=$($DIR_BASH/overlapping_tiles.sh)

lambda=1000	# divisé par  100
gamma=30		# divisé par  100
epsilon=500		# divisé par  100

REGULNAME=regul_Min_l$lambda\_g$gamma\_e$epsilon\_0_0_0

# Downscale SPOT6 images
files=""
res=1000 # resolution
cd $DIR_TILES
for ((i=${#tiles[@]}-1; i>=0; i--)); do
	tile=${tiles[i]}
	if [ ! -f "$DIR_TILES/im_$tile/Im_SPOT6_resized.visu.tif" ] 
		then
		WORK_DIR=$DIR_TILES/im_$tile
		rm -rf $WORK_DIR/*resized*
		gdal_translate -of GTiff -scale_1 128 620 0 255 -scale_2 204 648 0 255 -scale_3 229 623 0 255 -b 1 -b 2 -b 3 -outsize $res $res -q $WORK_DIR/Im_SPOT6.tif $WORK_DIR/Im_SPOT6_resized.visu.tif
		listgeo -tfw $WORK_DIR/Im_SPOT6_resized.visu.tif		
	fi
done

# merge smaller tiles
rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh 
SEG=""
for CUT in 3 8 15 20 30 50 70 90; do
	SEG=$SEG"Regul_Fusion/Seg/regul_seg_maj_$CUT.visu.tif "
done

for filename in  Im_SPOT6_resized.visu.tif classif_S2.visu.tif classif_SPOT6.visu.tif classif_Fusion_Min_weighted.visu.tif regul_Min_weighted_G2_l1000_g70_e500_0_0_0.visu.tif Regul_Fusion/Fusion/Classified/classif_Fusion_Min.visu.tif Regul_Fusion/Regul/$REGULNAME.visu.tif Regul_Fusion/Seg/Im_S2.tif ${SEG}; do
	files=""
	for ((i=${#tiles[@]}-1; i>=0; i--)); do
		# Original classification
		file="$DIR_TILES/im_${tiles[i]}/$filename"
		if [ -f $file ] 
			then
			files=$files$file" "
		fi
	done
	fname_out=all_$(basename ${filename} | cut -f1 -d ".").tif
	echo $fname_out
	echo -n "gdal_merge.py -of GTiff -o $DIR_RAM/$fname_out $files;" >> bashtmp.sh
	echo "mv $DIR_RAM/$fname_out $DIR_SAVE/$fname_out" >> bashtmp.sh
done

# MakeFile compilation
$DIR_EXES/Bash2Make bashtmp.sh makefiletmp
make -f makefiletmp -j 4
rm makefiletmp bashtmp.sh
echo "DONE"

# unmount and empty RAM directory
sudo umount -l $DIR_RAM
rm -rf $DIR_RAM
