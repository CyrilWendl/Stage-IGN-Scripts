# SPOT6
cd $DIR_RAM/im_$TILE_SPOT6
cp $IM_SPOT6 Im_SPOT6.tif
listgeo Im_SPOT6.tif -tfw

# For S2, take bands corresponding to RGB, NIR (bands 2, 3, 4, 8)
BANDS=""
for b in 2 3 4 8;do
	# crop
	bash $DIR_BASH/../raster_crop.sh $DIR_RAM/B$b.tif $DIR_RAM/im_$TILE_SPOT6/Im_SPOT6.tif $DIR_RAM/B$b-$b.tif	
	BANDS=$BANDS$DIR_RAM/"B$b-$b.tif " #names of band files for fusion
done

rm -rf Im_S2.tif # delete old image if exists
cp proba_SPOT6.tfw Im_S2.tfw

gdal_merge.py -separate $BANDS -o $DIR_RAM/im_$TILE_SPOT6/Im_S2.tif # merge bands

for b in 2 3 4 8;do
	rm -rf $DIR_RAM/B*.tif
done




