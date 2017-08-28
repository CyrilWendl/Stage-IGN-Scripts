DIR_OUT=/media/cyrilwendl/15BA65E227EC1B23/gironde/Data/Classif_Sentinel-2	# classification directory
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts 						# bash scripts directory
DIR_GT=/media/cyrilwendl/15BA65E227EC1B23/gironde/Data/BDTOPO				# ground truth directory
DIR_EXES=/home/cyrilwendl/DeveloppementBase/exes											# executables directory

cd $DIR_OUT
mkdir -p mask
rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh
rm -rf tmp*.shp
for i in BATI_INDIFFERENCIE BATI_INDUSTRIEL BATI_REMARQUABLE CONSTRUCTION_LEGERE ; do 
	echo -n "ogr2ogr -s_srs EPSG:2154 -t_srs EPSG:32630 tmp$i.shp $DIR_GT/E_BATI/${i}.SHP;" >> bashtmp.sh
	echo "ManipVecteur LectureBool tmp$i.shp emprise.ori mask/${i}.tif;rm -rf tmp$i*" >> bashtmp.sh
done

for i in ROUTE SURFACE_ROUTE ; do 
	echo -n "ogr2ogr -s_srs EPSG:2154 -t_srs EPSG:32630 tmp$i.shp $DIR_GT/A_RESEAU_ROUTIER/${i}.SHP;" >> bashtmp.sh
	echo "ManipVecteur LectureBool tmp$i.shp emprise.ori mask/${i}.tif;rm -rf tmp$i*" >> bashtmp.sh
done
for i in SURFACE_EAU ; do 
	echo -n "ogr2ogr -s_srs EPSG:2154 -t_srs EPSG:32630 tmp$i.shp $DIR_GT/D_HYDROGRAPHIE/${i}.SHP;" >> bashtmp.sh
	echo "ManipVecteur LectureBool tmp$i.shp emprise.ori mask/${i}.tif;rm -rf tmp$i*" >> bashtmp.sh
done
for i in AIRE_TRIAGE TRONCON_VOIE_FERREE ; do 
	echo -n "ogr2ogr -s_srs EPSG:2154 -t_srs EPSG:32630 tmp$i.shp $DIR_GT/B_VOIES_FERREES_ET_AUTRES/${i}.SHP;" >> bashtmp.sh
	echo "ManipVecteur LectureBool tmp$i.shp emprise.ori mask/${i}.tif;rm -rf tmp$i*" >> bashtmp.sh
done
for i in ZONE_VEGETATION ; do 
	echo -n "ogr2ogr -s_srs EPSG:2154 -t_srs EPSG:32630 tmp$i.shp $DIR_GT/F_VEGETATION/${i}.SHP;" >> bashtmp.sh
	echo "ManipVecteur LectureBool tmp$i.shp emprise.ori mask/${i}.tif;rm -rf tmp$i*" >> bashtmp.sh
done
echo -n "ogr2ogr -s_srs EPSG:2154 -t_srs EPSG:32630 tmp.shp $DIR_GT/RPG_2012_033/RPG_2012_033.shp;" >> bashtmp.sh
echo "ManipVecteur LectureBool tmp.shp emprise.ori mask/vegetation_autre.tif;" >> bashtmp.sh
$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 16
rm makefiletmp bashtmp.sh


# fusionner masques rasterisés
$DIR_EXES/Ech_noif FusMasques mask/BATI_INDIFFERENCIE.tif mask/BATI_INDUSTRIEL.tif mask/bati.tif
$DIR_EXES/Ech_noif FusMasques mask/bati.tif mask/BATI_REMARQUABLE.tif mask/bati.tif
$DIR_EXES/Ech_noif FusMasques mask/bati.tif mask/CONSTRUCTION_LEGERE.tif mask/bati.tif
$DIR_EXES/Ech_noif FusMasques mask/SURFACE_ROUTE.tif mask/ROUTE.tif mask/route.tif
$DIR_EXES/Ech_noif FusMasques mask/route.tif mask/TRONCON_VOIE_FERREE.tif mask/route.tif
for file in bati route; do
	$DIR_EXES/Ech_noif InverseBool mask/$file.tif mask/$file.tif
	$DIR_EXES/Ech_noif InverseBool mask/$file.tif mask/$file.tif
done

mv mask/SURFACE_EAU.tif mask/eau.tif
mv mask/ZONE_VEGETATION.tif mask/vegetation_foret.tif

# buffer autour des batiments
#$DIR_EXES/Ech_noif Dilat mask/bati.tif 10 mask/bati_dilat.tif

# fusionner tout
$DIR_EXES/Legende masques2label $DIR_BASH/legende.txt mask/ train_tout.rle
$DIR_EXES/Legende label2RVB $DIR_BASH/legende.txt train_tout.rle train.visu.tif

#$DIR_EXES/Ech_noif InverseBool masque_no_data.tif masque_no_data.tif 
#$DIR_EXES/Ech_noif AppliqueMasque train_tout.rle masque_no_data.tif train.rle
