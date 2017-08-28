#!bin/bash
RAMDIR="/media/cyrilwendl/15BA65E227EC1B23/tmp"
sudo umount $RAMDIR # allocate RAM memory
rm -Rf $RAMDIR
mkdir $RAMDIR
sudo mount -t tmpfs -o size=4g tmpfs $RAMDIR # allocate RAM memory

cd /media/cyrilwendl/Data/Images_SPOT6_finistere
tiles=($(ls | awk '(substr($1, 6, 5) >= 30000) && (substr($1, 12, 5) > 20000) && (substr($1, 6, 5) < 43000)' | awk '{print substr($0,6,11)}' | grep -E '[0-9]{2}[0]{3}'))
# all tile in 30000 <= x < 43000, y > 20000

lambda=1000	# divisé par  100
gamma=30		# divisé par  100
epsilon=500		# divisé par  100

REGULNAME=regul_Min_l$lambda\_g$gamma\_e$epsilon\_0_0_0

OUTDIR=/media/cyrilwendl/15BA65E227EC1B23

# Downscale SPOT6 images
files=""
res=1000 # resolution
cd $OUTDIR
for ((i=${#tiles[@]}-1; i>=0; i--)); do
	tile=${tiles[i]}
	echo $tile
	if [ ! -f "$OUTDIR/fusion/im_$tile/Im_SPOT6_resized.visu.tif" ] 
		then
		WORK_DIR=$OUTDIR/fusion/im_$tile
		rm -rf $WORK_DIR/*resized*
		gdal_translate -of GTiff -scale_1 128 620 0 255 -scale_2 204 648 0 255 -scale_3 229 623 0 255 -b 1 -b 2 -b 3 -outsize $res $res -q $WORK_DIR/Im_SPOT6.tif $WORK_DIR/Im_SPOT6_resized.visu.tif
		listgeo -tfw $OUTDIR/fusion/im_${tiles[i]}/Im_SPOT6_resized.visu.tif		
	else
		echo "File already exists."
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
		file="/media/cyrilwendl/15BA65E227EC1B23/fusion/im_${tiles[i]}/$filename"
		if [ -f $file ] 
			then
			files=$files$file" "
		fi
	done
	fname_out=all_$(basename ${filename} | cut -f1 -d ".").tif
	echo $fname_out
	echo -n "gdal_merge.py -of GTiff -o $RAMDIR/$fname_out $files;" >> bashtmp.sh
	echo "mv $RAMDIR/$fname_out /media/cyrilwendl/15BA65E227EC1B23/$fname_out" >> bashtmp.sh
done
# MakeFile compilation
~/DeveloppementBase/exes/Bash2Make bashtmp.sh makefiletmp
make -f makefiletmp -j 4
rm makefiletmp bashtmp.sh
echo "DONE"

# unmount and empty RAM directory
sudo umount -l $RAMDIR
rm -rf $RAMDIR
