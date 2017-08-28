# Crop and copy S2 and SPOT6 images to target directory
# S2 image:
#  a. Reproject to Lambert-93
#  b. Crop
#  c. Combine Bands
# S6 image: crop

cd
C1=$1

I1="/media/cyrilwendl/Data/Images_S2_finistere/20170525" # image S2
I2="/media/cyrilwendl/Data/Images_SPOT6_finistere/tile_$C1.tif" # image SPOT6 (for reference)
RAMDIR="/home/cyrilwendl/Documents/tmp"

# SPOT6
cd $RAMDIR/im_$C1
cp $I2 Im_SPOT6.tif
listgeo Im_SPOT6.tif -tfw

# For S2, take bands corresponding to RGB, NIR (bands 2, 3, 4, 8)


RAMDIR="/home/cyrilwendl/Documents/tmp"

BANDS=""
for b in 2 3 4 8;do
	# crop
	bash ~/DeveloppementBase/Scripts/raster-crop.sh $RAMDIR/B$b.tif $RAMDIR/im_$C1/Im_SPOT6.tif $RAMDIR/B$b-$b.tif	
	BANDS=$BANDS$RAMDIR/"B$b-$b.tif " #names of band files for fusion
done

rm -rf Im_S2.tif # delete old image if exists
cp proba_SPOT6.tfw Im_S2.tfw

gdal_merge.py -separate $BANDS -o $RAMDIR/im_$C1/Im_S2.tif # merge bands

for b in 2 3 4 8;do
	rm -rf $RAMDIR/B*.tif
done




