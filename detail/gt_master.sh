#!/usr/bin/env bash
# create a few ground truth maps for a given tile
REGION=$1
TILE_SPOT6=$2
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts/detail
DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6/gt

echo "1. OSM"
bash $DIR_BASH/gt_osm.sh $REGION $TILE_SPOT6
echo "2. OSO"
bash $DIR_BASH/gt_oso.sh $REGION $TILE_SPOT6
echo "3. BDTOPO"
bash $DIR_BASH/gt_bdtopo.sh $REGION $TILE_SPOT6

# visualize
cd $DIR_SAVE
for gt in osm oso bdtopo bdtopo_original; do
	Legende label2RVB $DIR_BASH/legende_agg_oso.txt train_$gt.tif train_$gt.visu.tif
	convert train_$gt.visu.tif train_$gt.jpg
done
