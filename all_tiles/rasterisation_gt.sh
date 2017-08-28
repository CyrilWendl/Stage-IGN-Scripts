cd ~/fusion/im_$1

# emprise
cp proba_SPOT6.ori emprise.ori

# rasterisation des fichiers vecteur
mkdir mask

# parallelization
rm -rf makefiletmp bashtmp.sh
touch bashtmp.sh
for i in BATI_INDIFFERENCIE BATI_INDUSTRIEL BATI_REMARQUABLE CONSTRUCTION_LEGERE ; do 
echo "~/DeveloppementBase/exes/ManipVecteur LectureBool /media/cyrilwendl/Data/VeriteTerrain/BDTOPO_2-1_TOUSTHEMES_SHP_LAMB93_D029_2015-03-26/BDTOPO/1_DONNEES_LIVRAISON_2015-04-00253/BDT_2-1_SHP_LAMB93_D029-ED151/E_BATI/${i}.SHP emprise.ori mask/${i}.tif ; " >> bashtmp.sh
done
for i in ROUTE SURFACE_ROUTE ; do 
echo "~/DeveloppementBase/exes/ManipVecteur LectureBool /media/cyrilwendl/Data/VeriteTerrain/BDTOPO_2-1_TOUSTHEMES_SHP_LAMB93_D029_2015-03-26/BDTOPO/1_DONNEES_LIVRAISON_2015-04-00253/BDT_2-1_SHP_LAMB93_D029-ED151/A_RESEAU_ROUTIER/${i}.SHP emprise.ori mask/${i}.tif ; " >> bashtmp.sh 
done
for i in SURFACE_EAU ; do
echo "~/DeveloppementBase/exes/ManipVecteur LectureBool /media/cyrilwendl/Data/VeriteTerrain/BDTOPO_2-1_TOUSTHEMES_SHP_LAMB93_D029_2015-03-26/BDTOPO/1_DONNEES_LIVRAISON_2015-04-00253/BDT_2-1_SHP_LAMB93_D029-ED151/D_HYDROGRAPHIE/${i}.SHP emprise.ori mask/${i}.tif ; " >> bashtmp.sh 
done
for i in AIRE_TRIAGE TRONCON_VOIE_FERREE ; do 
echo "~/DeveloppementBase/exes/ManipVecteur LectureBool /media/cyrilwendl/Data/VeriteTerrain/BDTOPO_2-1_TOUSTHEMES_SHP_LAMB93_D029_2015-03-26/BDTOPO/1_DONNEES_LIVRAISON_2015-04-00253/BDT_2-1_SHP_LAMB93_D029-ED151/B_VOIES_FERREES_ET_AUTRES/${i}.SHP emprise.ori mask/${i}.tif ; " >> bashtmp.sh 
done
for i in ZONE_VEGETATION ; do
echo "~/DeveloppementBase/exes/ManipVecteur LectureBool /media/cyrilwendl/Data/VeriteTerrain/BDTOPO_2-1_TOUSTHEMES_SHP_LAMB93_D029_2015-03-26/BDTOPO/1_DONNEES_LIVRAISON_2015-04-00253/BDT_2-1_SHP_LAMB93_D029-ED151/F_VEGETATION/${i}.SHP emprise.ori mask/${i}.tif ; " >> bashtmp.sh 
done

~/DeveloppementBase/exes/Bash2Make bashtmp.sh makefiletmp # MakeFile compilation
make -f makefiletmp -j 10
rm makefiletmp bashtmp.sh

~/DeveloppementBase/exes/ManipVecteur LectureBool /media/cyrilwendl/Data/VeriteTerrain/RPG_2012_029/RPG_2012_029.shp emprise.ori mask/culture.tif

# fusionner masques rasterisés
~/DeveloppementBase/exes/Ech_noif FusMasques mask/BATI_INDIFFERENCIE.tif mask/BATI_INDUSTRIEL.tif mask/bati.tif
~/DeveloppementBase/exes/Ech_noif FusMasques mask/bati.tif mask/BATI_REMARQUABLE.tif mask/bati.tif
~/DeveloppementBase/exes/Ech_noif FusMasques mask/bati.tif mask/CONSTRUCTION_LEGERE.tif mask/bati.tif
~/DeveloppementBase/exes/Ech_noif InverseBool mask/bati.tif mask/bati.tif
~/DeveloppementBase/exes/Ech_noif InverseBool mask/bati.tif mask/bati.tif

~/DeveloppementBase/exes/Ech_noif FusMasques mask/SURFACE_ROUTE.tif mask/ROUTE.tif mask/route.tif
~/DeveloppementBase/exes/Ech_noif FusMasques mask/route.tif mask/TRONCON_VOIE_FERREE.tif mask/route.tif
~/DeveloppementBase/exes/Ech_noif InverseBool mask/route.tif mask/route.tif
~/DeveloppementBase/exes/Ech_noif InverseBool mask/route.tif mask/route.tif

mv mask/SURFACE_EAU.tif mask/eau.tif
mv mask/ZONE_VEGETATION.tif mask/vegetation_foret.tif
mv mask/culture.tif mask/vegetation_autre.tif

# fusionner tout
~/DeveloppementBase/exes/Legende masques2label legende.txt mask/ train_tout.rle
~/DeveloppementBase/exes/Legende label2RVB legende.txt train_tout.rle train.visu.tif # visualisation
cp proba_SPOT6.tfw train.visu.tfw

# masque binaire
LEGENDE=~/DeveloppementBase/Scripts/legende_agg.txt
~/DeveloppementBase/exes/Legende aggrege $LEGENDE train_tout.rle train_tout_bin.rle

rm -Rf ./mask/
#~/DeveloppementBase/exes/Ech_noif InverseBool masque_no_data.tif masque_no_data.tif 
#~/DeveloppementBase/exes/Ech_noif AppliqueMasque train_tout.rle masque_no_data.tif train.rle
