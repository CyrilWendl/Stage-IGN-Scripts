#!bin/bash
# usage: 	bash DeveloppementBase/Scripts/report_images_resize.sh [tile number] [cropping window x y dx dy]
# e.g. 		bash DeveloppementBase/Scripts/report_images_resize.sh 41000_30000 340 420 800 800
# output: subfolder im_TILE/web with all tiles cropped to output size

DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/detail/im_$1 # target directory to save probability
cd $DIR_SAVE
rm -rf web/*
mkdir -p web

# Copy original image
gdal_contrast_stretch -percentile-range 0.02 0.98 Im_SPOT6.tif Im_SPOT6_stretched.tif
convert Im_SPOT6_stretched.tif Im_SPOT6.jpg # rescale between [0, 255], only keep 3 bands
rm Im_SPOT6_stretched.tif
# Crop SPOT6 image
convert $DIR_SAVE/Im_SPOT6.jpg -crop $4"X"$5+$2+$3 $DIR_SAVE/web/Im_SPOT6_crop.jpg
# Resize SPOT6 image 
convert $DIR_SAVE/Im_SPOT6.jpg -resize 1000X1000 $DIR_SAVE/web/Im_SPOT6_resized.jpg
# Draw red rectangle
convert $DIR_SAVE/Im_SPOT6.jpg -fill red -stroke red -strokewidth 3 -draw "fill-opacity 0.3 rectangle $2, $3, $(expr $2 + $4), $(expr $3 + $5)" $DIR_SAVE/web/Im_SPOT6.jpg  # copy and crop original image [widthXXwidthY+startposx+startposy]

for subdir in "./Classified" "./Fusion_all_weighted/Classified" "./Regul" ; do #"./Regul_Fusion"
	cd $DIR_SAVE/$subdir
	for i in *.visu.tif; do
		echo $i
		rm -rf *overlay*
		convert $i -crop $4"X"$5+$2+$3  $DIR_SAVE/web/T$1_${i%.visu.tif}.jpg  # copy and crop original image [widthXXwidthY+startposx+startposy]
		
		# comment out the following lines to not show background
		composite -blend 30% $DIR_SAVE/web/Im_SPOT6_crop.jpg $DIR_SAVE/web/T$1_${i%.visu.tif}.jpg overlay_T$1_${i%.visu.tif}.jpg
		mv overlay_T$1_${i%.visu.tif}.jpg $DIR_SAVE/web/T$1_${i%.visu.tif}.jpg
	done
done

convert $DIR_SAVE/train.visu.tif -crop $4"X"$5+$2+$3  $DIR_SAVE/web/T$1_train.jpg

# copy fusion and regularization results (convert to jpg)
for file in Classified/classif_S2_urbain Classified/classif_regul_urbain Regul/regul_proba_Fusion_Min_100_1000_100_0_100_70_100_200_0_0_0 Fusion/Classified/classif_Fusion_Min; do
	convert $DIR_SAVE/Regul_Fusion/$file.visu.tif -resize 1000X1000 $DIR_SAVE/web/R2_T$1_$(basename $file).jpg
	#overlay map
	composite -blend 50% $DIR_SAVE/web/Im_SPOT6_resized.jpg $DIR_SAVE/web/R2_T$1_$(basename $file).jpg overlay_R2_T$1_$(basename $file).jpg
	mv overlay_R2_T$1_$(basename $file).jpg $DIR_SAVE/web/R2_T$1_$(basename $file).jpg
done

# copy segmentation results
for n in 3 8 15 20 30; do
	convert $DIR_SAVE/Regul_Fusion/Seg/regul_seg_maj_$n.visu.tif -resize 1000X1000 $DIR_SAVE/web/regul_seg_maj_$n.jpg
	#overlay map
	composite -blend 50% $DIR_SAVE/web/Im_SPOT6_resized.jpg $DIR_SAVE/web/regul_seg_maj_$n.jpg overlay_regul_seg_maj_$n.jpg
	mv overlay_regul_seg_maj_$n.jpg $DIR_SAVE/web/regul_seg_maj_$n.jpg
done
