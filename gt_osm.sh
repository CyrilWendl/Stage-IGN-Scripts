# Extract ground truth for artificialized area from OpenStreetMaps
REGION=$1
TILE_SPOT6=$2
DIR_OSM=/media/cyrilwendl/15BA65E227EC1B23/data/OSM/$REGION
EXTENT=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6/Im_SPOT6.tif
DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/detail/im_$TILE_SPOT6/gt

rm -Rf $DIR_SAVE/*
mkdir -p $DIR_SAVE

cd $DIR_OSM
rm -Rf *temp* *tmp*

#rename input file gis.osm_landuse_a_free_1.shp to landuse.shp
mmv 'gis.osm_landuse_a_free_1.*' 'landuse.#1'

# crop and extract residential areas
gdaltindex -t_srs EPSG:4326 -src_srs_name src_srs tmp.shp $EXTENT
ogr2ogr -sql "SELECT * FROM landuse WHERE fclass = 'residential'" -clipsrc tmp.shp temp.shp landuse.shp

# rasterize
gdal_rasterize -ot Byte -ts 2069 2069 -burn 1 -l temp temp.shp OSM_residential.tif

# copy to target directory
cp OSM_residential.tif $DIR_SAVE/
rm -Rf *temp* *tmp*

# create jpg
cd $DIR_SAVE
gdal_translate -of JPEG -scale -co worldfile=yes OSM_residential.tif OSM_residential.jpg
rm -Rf *.aux *.wld *.xml
