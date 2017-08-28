# Crop and copy S2 and SPOT6 images to target directory
# S2 image: reproject to Lambert-93, crop, combine bands
# S6 image: crop
cd $DIR_SAVE

# SPOT6
cp $IM_SPOT6 $DIR_SAVE/Im_SPOT6.tif
cp proba_SPOT6.tfw Im_SPOT6.tfw

# Crop SPOT6
if [ "$8" = "crop" ]; then
	gdal_translate -srcwin $9 ${10} ${11} ${12} $IM_SPOT6 $DIR_SAVE/Im_SPOT6.tif
	listgeo $DIR_SAVE/Im_SPOT6.tif -tfw
fi

# For S2, take bands corresponding to RGB, NIR (bands 2, 3, 4, 8)
# create partition to work in RAM
sudo umount $DIR_RAM # allocate RAM memory
rm -Rf $DIR_RAM
mkdir $DIR_RAM
sudo mount -t tmpfs -o size=4g tmpfs $DIR_RAM # allocate RAM memory

rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh # parallelize: bash file with commands

BANDS=""
for b in 2 3 4 8;do
	# a. Reprojeter
	rm -rf $DIR_SAVE/B$b.tif	
	echo - "gdalwarp -s_srs EPSG:32630 -t_srs EPSG:2154 $DIR_IM_S2/B$b.tif $DIR_RAM/B$b.tif" >> bashtmp.sh
done

$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 4
rm makefiletmp bashtmp.sh
echo "DONE"

BANDS=""
for b in 2 3 4 8;do
	bash $DIR_BASH/crop_raster.sh $DIR_RAM/B$b.tif $DIR_SAVE/Im_SPOT6.tif $DIR_RAM/B$b-$b.tif
	BANDS=$BANDS$DIR_RAM/"B$b-$b.tif " #names of band files for fusion
done

rm -rf Im_S2.tif # delete old image if exists
gdal_merge.py -separate $BANDS -o $DIR_SAVE/Im_S2.tif # merge bands

cp $DIR_SAVE/proba_SPOT6.tfw $DIR_SAVE/Im_S2.tfw 

# unmount and empty RAM directory
sudo umount -l $DIR_RAM
rm -rf $DIR_RAM
