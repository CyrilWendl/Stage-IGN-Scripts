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

# For S2, take bands corresponding to RGB, NIR (bands 2, 3, 4, 8)
# create partition to work in RAM
RAMDIR="/home/cyrilwendl/Documents/tmp"
cd $RAMDIR

rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh # parallelize: bash file with commands

for b in 2 3 4 8;do
	# a. Reprojeter
	echo "gdalwarp -s_srs EPSG:32630 -t_srs EPSG:2154 $I1/B$b.tif $RAMDIR/B$b.tif" >> bashtmp.sh
done

~/DeveloppementBase/exes/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 4
rm makefiletmp bashtmp.sh
echo "DONE"
