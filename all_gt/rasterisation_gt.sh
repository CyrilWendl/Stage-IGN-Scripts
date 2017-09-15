REGION=finistere # command line
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts/all_gt
DIR_EXES=$DIR_BASH/../exes
DIR_DATA=/media/cyrilwendl/15BA65E227EC1B23/$REGION/data
DIR_GT=$DIR_DATA/GT/BDTOPO # Grond truth directory
DIR_SAVE=/media/cyrilwendl/15BA65E227EC1B23/$REGION/all
DEPT=029 # Grond truth: department for RPG

cd $DIR_SAVE

# emprise
rm -rf *emprise*
listgeo -tfw all_Im_SPOT6_resized.tif
cp all_Im_SPOT6_resized.tfw emprise.tfw
$DIR_EXES/convert_ori tfw2ori emprise.tfw emprise.ori
$DIR_EXES/convert_ori tfw2ori all_Im_SPOT6_resized.tfw emprise.ori
ls | grep emprise
# rasterisation des fichiers vecteur
rm -Rf mask
mkdir -p mask

# extraire rasters
rm -rf makefiletmp bashtmp.sh # parallelization
touch bashtmp.sh
for i in BATI_INDIFFERENCIE BATI_INDUSTRIEL BATI_REMARQUABLE CONSTRUCTION_LEGERE ; do 
	echo "$DIR_EXES/ManipVecteur LectureBool $DIR_GT/E_BATI/${i}.SHP emprise.ori mask/${i}.tif" >> bashtmp.sh
done
for i in ROUTE SURFACE_ROUTE ; do 
	echo "$DIR_EXES/ManipVecteur LectureLignesLargeurBool $DIR_GT/A_RESEAU_ROUTIER/${i}.SHP emprise.ori mask/${i}.tif 15 2" >> bashtmp.sh 
done
for i in SURFACE_EAU ; do
	echo "$DIR_EXES/ManipVecteur LectureBool $DIR_GT/D_HYDROGRAPHIE/${i}.SHP emprise.ori mask/${i}.tif" >> bashtmp.sh 
done
for i in AIRE_TRIAGE TRONCON_VOIE_FERREE ; do 
	echo "$DIR_EXES/ManipVecteur LectureBool $DIR_GT/B_VOIES_FERREES_ET_AUTRES/${i}.SHP emprise.ori mask/${i}.tif" >> bashtmp.sh 
done
echo "$DIR_EXES/ManipVecteur LectureBool $DIR_GT/F_VEGETATION/ZONE_VEGETATION.SHP emprise.ori mask/vegetation_foret.tif" >> bashtmp.sh
echo "$DIR_EXES/ManipVecteur LectureBool $DIR_GT/../RPG/RPG_2012_$DEPT.shp emprise.ori mask/culture.tif" >> bashtmp.sh  

$DIR_EXES/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 10
rm makefiletmp bashtmp.sh

# fusionner masques rasterisés
$DIR_EXES/Ech_noif FusMasques mask/BATI_INDIFFERENCIE.tif mask/BATI_INDUSTRIEL.tif mask/bati.tif
$DIR_EXES/Ech_noif FusMasques mask/bati.tif mask/BATI_REMARQUABLE.tif mask/bati.tif
$DIR_EXES/Ech_noif FusMasques mask/bati.tif mask/CONSTRUCTION_LEGERE.tif mask/bati.tif
$DIR_EXES/Ech_noif FusMasques mask/SURFACE_ROUTE.tif mask/ROUTE.tif mask/route.tif
$DIR_EXES/Ech_noif FusMasques mask/route.tif mask/TRONCON_VOIE_FERREE.tif mask/route.tif

mv mask/SURFACE_EAU.tif mask/eau.tif
mv mask/culture.tif mask/vegetation_autre.tif

# buffer autour des batiments
$DIR_EXES/Ech_noif Dilat mask/bati.tif 10 mask/bati_dilat.tif

# fusionner tout
$DIR_EXES/Legende masques2label $DIR_BASH/../tools/legende_gt_6cl.txt mask/ train_tout.rle
$DIR_EXES/Legende label2RVB $DIR_BASH/../tools/legende_gt_6cl.txt train_tout.rle train.visu.tif # visualisation
cp emprise.tfw train.visu.tfw

# masque binaire
$DIR_EXES/Legende aggrege $DIR_BASH/../tools/legende_agg_bin.txt train_tout.rle train_tout_bin.rle
rm -Rf ./mask/
#$DIR_EXES/Ech_noif InverseBool masque_no_data.tif masque_no_data.tif 
#$DIR_EXES/Ech_noif AppliqueMasque train_tout.rle masque_no_data.tif train.rle
