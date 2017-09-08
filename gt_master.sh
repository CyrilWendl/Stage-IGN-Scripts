#!/usr/bin/env bash
# create a few ground truth maps for a given tile
REGION=$1
TILE_SPOT6=$2
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
echo "1. OSM"
bash $DIR_BASH/gt_osm.sh $REGION $TILE_SPOT6
echo "2. OSO"
bash $DIR_BASH/gt_oso.sh $REGION $TILE_SPOT6
echo "3. BDTOPO"
bash $DIR_BASH/gt_bdtopo.sh $REGION $TILE_SPOT6
