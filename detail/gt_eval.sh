# produce validity maps for each binary classification and GT pair
REGION=$1
TILE_SPOT6=$2
DIR_SPOT6=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts/detail
DIR_EXES=$DIR_BASH/../exes

mkdir -p $DIR_SPOT6/gt/eval
cd $DIR_SPOT6/gt/eval
rm -rf * ../*resized*

for compare in Classified/classif_regul_urbain Classified/classif_S2_urbain Fusion/Classified/classif_Fusion_Min Fusion/Classified/classif_Fusion_Bayes Regul/regul_proba_Fusion_Min_100_1000_100_0_100_70_100_200_0_0_0 Seg/regul_seg_maj_3; do
	mkdir $(basename $compare)
	FILE_IM=$DIR_SPOT6/Binary/$compare
	Ech_noif Format $FILE_IM.rle $FILE_IM.tif
	#resize to resolution of tile
	gdal_translate -outsize 2069 2069 -of GTiff $FILE_IM.tif $DIR_SPOT6/gt/eval/$(basename $compare)-resized.tif
	FILE_IM=$DIR_SPOT6/gt/eval/$(basename $compare)-resized
	for methode in bdtopo oso osm; do
		FILE_GT=$DIR_SPOT6/gt/train_$methode
		#gdal_translate -outsize 315 315 -of GTiff $FILE_GT.tif $FILE_GT-resized.tif
		compare=$(basename $compare)
		gdal_calc.py -A $FILE_GT.tif -B $FILE_IM.tif --calc='A*2+(B-1)' --outfile="$DIR_SPOT6/gt/eval/$methode-$compare.tif"
		# visualize
		$DIR_EXES/Legende label2RVB $DIR_BASH/../legende_bin_eval.txt $DIR_SPOT6/gt/eval/$methode-$compare.tif "$DIR_SPOT6/gt/eval/$methode-$compare.visu.tif"
	done
	mv *.* $(basename $compare)
done


