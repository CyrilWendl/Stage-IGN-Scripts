# create a few ground truth maps for a given tile
export REGION=finistere
export DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
export DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/all/gt
export DIR_EXES=$DIR_BASH/exes
export EXTENT=$DIR_SAVE/../all_Im_SPOT6_resized.tif
export DIR_OSM=/media/cyrilwendl/15BA65E227EC1B23/data/OSM/$REGION
export DIR_OSO=/media/cyrilwendl/15BA65E227EC1B23/data/OSO


#rm -Rf $DIR_SAVE/*
mkdir -p $DIR_SAVE

# extract ground truths

echo "BDTOPO"
#bash $DIR_BASH/all/rasterisation_gt.sh
#bash $DIR_BASH/all/gt_bdtopo.sh
echo "OSO"
#bash $DIR_BASH/all/gt_oso.sh
echo "OSM"
#bash $DIR_BASH/all/gt_osm.sh

echo "VISUALIZE"
cd $DIR_SAVE
for gt in osm oso bdtopo_dilat bdtopo; do
	Legende label2RVB $DIR_BASH/legende_agg_oso.txt train_$gt.tif train_$gt.visu.tif
	convert train_$gt.visu.tif train_$gt.jpg
done
