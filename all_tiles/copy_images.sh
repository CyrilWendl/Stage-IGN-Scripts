# For S2, take bands corresponding to RGB, NIR (bands 2, 3, 4, 8)
# create partition to work in RAM
cd $DIR_RAM

rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh # parallelize: bash file with commands

for b in 2 3 4 8;do
	# a. Reprojeter
	echo "gdalwarp -s_srs EPSG:32630 -t_srs EPSG:2154 $DIR_IM_S2/B$b.tif $DIR_RAM/B$b.tif" >> bashtmp.sh
done

$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 4
rm makefiletmp bashtmp.sh
echo "DONE"

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
