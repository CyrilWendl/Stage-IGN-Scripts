# Extract ground truth for artificialized area from OpenStreetMaps
REGION=$1
TILE_SPOT6=$2
DIR_OSM=/media/cyrilwendl/15BA65E227EC1B23/data/OSM/$REGION
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
EXTENT=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6/proba_SPOT6.tif
DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6/gt

rm -Rf $DIR_SAVE/*
mkdir -p $DIR_SAVE

cd $DIR_OSM
rm -Rf *temp* *tmp* *landuse93* *OSM_residential*

# crop and extract residential areas
mcp -o -d 'gis.osm_landuse_a_free_1.*' 'landuse.#1' # rename files to landuse
gdaltindex -t_srs EPSG:2154 -src_srs_name src_srs temp-extent.shp $EXTENT # get extent SHP
ogr2ogr landuse93.shp -t_srs "EPSG:2154" landuse.shp # change CRS
ogr2ogr -sql "SELECT * FROM landuse93 WHERE fclass = 'residential'" -clipsrc temp-extent.shp temp-landuse-crop.shp landuse93.shp # crop SHP 

# rasterize
EXT=$(python $DIR_BASH/tools/raster_extent.py $EXTENT) # get raster extent

gdal_rasterize -ot Byte -ts 2069 2069 -te $EXT -a_srs EPSG:2154 -burn 1 -l temp-landuse-crop temp-landuse-crop.shp $DIR_SAVE/train_osm.tif

rm -Rf *temp* *tmp*
cp $DIR_SAVE/../Im_SPOT6.tfw $DIR_SAVE/train_osm.tfw
