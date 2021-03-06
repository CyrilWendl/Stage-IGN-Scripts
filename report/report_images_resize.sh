# usage:  bash report_images_resize.sh [region] [tile number] [cropping window x y dx dy]
# e.g.    bash report_images_resize.sh finistere 41000_30000 340 420 800 800
# output: subfolder im_TILE/web with all tiles cropped to output size

# input
REGION=$1
TILE_SPOT6=$2
X=$3
Y=$4
DX=$5
DY=$6

DIR_SAVE=/Users/cyrilwendl/Documents/Stages/IGN/Data/$REGION/detail/im_${TILE_SPOT6} # target directory to save probability
cd $DIR_SAVE
rm -rf web/*
mkdir -p web

echo 
printf "Parameters: \n REGION=%s\nTILE_SPOT6=%s\nX=%s, Y=%s DX=%s DY=%s\n" $REGION $TILE_SPOT6 $X $Y $DX $DY >> $DIR_SAVE/log.txt

# Copy original image
gdal_contrast_stretch -percentile-range 0.02 0.98 Im_SPOT6.tif Im_SPOT6_stretched.tif
convert Im_SPOT6_stretched.tif Im_SPOT6.jpg # rescale between [0, 255], only keep 3 bands
rm Im_SPOT6_stretched.tif
# Crop SPOT6 image
convert $DIR_SAVE/Im_SPOT6.jpg -crop ${DX}"X"${DY}+${X}+${Y} $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_Im_SPOT6_crop.jpg
# Resize SPOT6 image 
convert $DIR_SAVE/Im_SPOT6.jpg -resize 1000X1000 $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_Im_SPOT6_resized.jpg
# Draw red rectangle
convert $DIR_SAVE/Im_SPOT6.jpg -fill red -stroke red -strokewidth 3 -draw "fill-opacity 0.3 rectangle ${X}, ${Y}, $(expr ${X} + ${DX}), $(expr ${Y} + ${DY})" $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_Im_SPOT6.jpg  # copy and crop original image [widthXXwidthY+startposx+startposy]


# artificialized area steps
#for filename in 1_bati 2_dist 3_bati-dist 4_proba_regul_urbain; do
#	convert $DIR_SAVE/Binary/Temp/binary_$filename.jpg -resize 1000X1000 $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_binary_$filename.jpg
	#overlay map
#	composite -blend 20% $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_Im_SPOT6_resized.jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_binary_$filename.jpg overlay_${REGION}_T${TILE_SPOT6}_binary_$filename.jpg
#	mv overlay_${REGION}_T${TILE_SPOT6}_binary_$filename.jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_binary_$filename.jpg
#done
#exit ###

# 5 class classifications
for subdir in "./Classified" "./Fusion_all/Classified" "./Fusion_all_weighted/Classified" "./Regul" ; do
	cd $DIR_SAVE/$subdir
	for i in *.visu.tif; do
		echo $i
		rm -rf *overlay*
		convert $i -crop ${DX}"X"${DY}+${X}+${Y}  $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_${i%.visu.tif}.jpg  # copy and crop original image [widthXXwidthY+startposx+startposy]
		
		# comment out the following lines to not show background
		composite -blend 50% $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_Im_SPOT6_crop.jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_${i%.visu.tif}.jpg overlay_T${TILE_SPOT6}_${i%.visu.tif}.jpg
		mv overlay_T${TILE_SPOT6}_${i%.visu.tif}.jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_${i%.visu.tif}.jpg
	done
done

convert $DIR_SAVE/train.visu.tif -crop ${DX}"X"${DY}+${X}+${Y}  $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_train.jpg

# fusion and regularization results (convert to jpg)
for file in Classified/classif_S2_urbain Classified/classif_regul_urbain Regul/regul_proba_Fusion_Min_100_1000_100_0_100_70_100_200_0_0_0 Fusion/Classified/classif_Fusion_Min; do
	convert $DIR_SAVE/Binary/$file.visu.tif -resize 1000X1000 $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_BIN_$(basename $file).jpg
	#overlay map
	composite -blend 50% $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_Im_SPOT6_resized.jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_BIN_$(basename $file).jpg overlay_BIN_T${TILE_SPOT6}_$(basename $file).jpg
	mv overlay_BIN_T${TILE_SPOT6}_$(basename $file).jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_BIN_$(basename $file).jpg
done

# segmentation results
for n in 3 8 15 20 30; do
	convert $DIR_SAVE/Binary/Seg/regul_seg_maj_$n.visu.tif -resize 1000X1000 $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_regul_seg_maj_$n.jpg
	#overlay map
	composite -blend 50% $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_Im_SPOT6_resized.jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_regul_seg_maj_$n.jpg overlay_regul_seg_maj_$n.jpg
	mv overlay_regul_seg_maj_$n.jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_regul_seg_maj_$n.jpg
done

# ground truth
for method in bdtopo oso osm; do
	convert $DIR_SAVE/gt/train_$method.jpg -resize 1000X1000 $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_gt_$method.jpg
	#overlay map
	composite -blend 50% $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_Im_SPOT6_resized.jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_gt_$method.jpg overlay_T${TILE_SPOT6}_gt_$method.jpg
	mv overlay_T${TILE_SPOT6}_gt_$method.jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_gt_$method.jpg
	#binary evaluation
	convert $DIR_SAVE/gt/eval/regul_seg_maj_8/${REGION}_T${TILE_SPOT6}_$method-regul_seg_maj_8.jpg -resize 1000X1000 $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_gt_eval_$method-regul_seg_maj_8.jpg
	composite -blend 50% $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_Im_SPOT6_resized.jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_gt_eval_$method-regul_seg_maj_8.jpg overlay_${REGION}_T${TILE_SPOT6}_$method-regul_seg_maj_8.jpg
	mv overlay_${REGION}_T${TILE_SPOT6}_$method-regul_seg_maj_8.jpg $DIR_SAVE/web/${REGION}_T${TILE_SPOT6}_gt_eval_$method-regul_seg_maj_8.jpg	
done
