# create a few ground truth maps for a given tile
export REGION=$1
export TILE_SPOT6=$2

# TODO set variables below
export DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
export DIR_IM=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6
export DIR_DATA=/media/cyrilwendl/15BA65E227EC1B23/data
export DIR_EXES=$DIR_BASH/exes

export DIR_OSM=$DIR_DATA/OSM/$REGION
export DIR_OSO=$DIR_DATA/OSO

export DIR_SAVE_GT=$DIR_IM/gt

export EXTENT=$DIR_IM/proba_SPOT6.tif

#rm -Rf $DIR_SAVE_GT/*
mkdir -p $DIR_SAVE_GT
cd $DIR_SAVE_GT

echo "EVALUATION"
bash $DIR_BASH/detail_binary/gt_eval_label.sh $REGION
exit

echo "OSM"
bash $DIR_BASH/detail_binary/gt_osm.sh
echo "OSO"
bash $DIR_BASH/detail_binary/gt_oso.sh
echo "BDTOPO"
bash $DIR_BASH/detail_binary/gt_bdtopo.sh
echo "VISUALIZE"
cd $DIR_SAVE_GT
for gt in osm oso bdtopo bdtopo_original; do
	Legende label2RVB $DIR_BASH/tools/legende_bin.txt train_$gt.tif train_$gt.visu.tif
	convert train_$gt.visu.tif train_$gt.jpg
done


