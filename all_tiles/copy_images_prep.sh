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
