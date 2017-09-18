# Ligne de commande
## Rasterisation, Vectorisation
**ManipVecteur** (contient aide)
Pour rasteriser un fichier vectoriel

_Polygones_
`ManipVecteur LectureGenerale [shape_in].SHP [emprise].ori [out].[tif/rle]`
` ManipVecteur LectureBool [shape_in].SHP [emprise].ori [out].[tif/rle] ; `
Rastériser fiches vecteurs et créer masque pour l’emprise contenue dans emprise.ori.
- `LectureGenerale` : rasteriser shapefile en ajoutant un attribut (incrément) pour chaque polygone distinct
- `LectureBool` : rasteriser shapefile en 0 et 1

_Lignes_
`LecturLignesLargeurBool`, largeur en 3ème argument = colonne du fichier entrée

`ManipVecteur LectureLignesLargeurBool adresse_vecteur [shp| adresse_ori adresse_enregistrement_raster [tif][numero_champ_largeur] [facteur_multiplicatif_largeur]`
Exemple: `ManipVecteur LectureLignesLargeurBool [shapefile_route].shp [target_extent].ori route.tif 15 1`

Pour vectoriser un fichier raster :
`ManipVecteur Vectorisation bati.tif bati.shp`

## Visualisation, labels
**Legende** (contient aide)
`Legende RVB2label legende.txt test.tif test_label.tif`
Crate labels (1, 2, 3...) from classified image, legend.txt:
`[Class name ][Class number ] [RGB values]`
e.g.,
`Road 1 255 255 0`

`Legende label2masques legende.txt test_label.tif masktmp/`
sauvegarder masque binaire de chaque classe individuellement dans le répertoire masktmp/

`Legende masques2label legende.txt mask/ labels.rle`
Pour mettre dans un fichier labels.rle les labels en utilisant les masques dans mask/ en trouvant la classe grâce à legende.txt

Faire attention à l’ordre : selon l’ordre la route va être au-dessus de la forêt p. ex. ou vice-versa

`Legende label2masqueunique legende.txt test_label.tif 3 4 5 masktmp/nonurbain.tif`
Sauvegarder masque binaire des pixels étant dans la classe 3, 4 ou 5 en masktmp/nonurbain.tif

`Legende label2RVB legende.txt classif_S2_urbnonurb.rle classif_S2_urbnonurb.tif`
Pour afficher en couleurs (spécifiées en legende.txt) la classification.

## Format, masques, conversion
**Ech_noif**

`Ech_noif ClassifTristanCSV2TIF pixelwiseListFiles.csv pixelwiseListLabels.csv proba.tif`
Sortir probabilités en un fichier .tif (dans le répertoire `/finistere1/test_41000_30000/classification_results/preds`) en utilisant les coordonnées (premier fichier en entrée (`ListFiles`) et les labels (`ListLabels`).

`Ech_noif FusMasques bati_industriel.tif bati_indifferencie.tif bati.tif`
Pour fusionner deux masques raster(binaires)

Le fichier `bati.tif` en sortie contient des flottants (1.0f et 0.0f), pour le convertir en int on peut appliquer deux fois :
`Ech_noif InverseBool bati.tif bati.tif`

`Ech_noif Format $filename.tif $filename.rle`
Conversion d’un fichier tif au format rle 

**convert_ori** (contient aide)
conversion du système de projection .tfw en .ori (IGN-internal)
classif_test_41000_30000.visu.tfw > Proba.tfw
`convert_ori tfw2ori proba.tfw proba.ori`
`> more proba.ori`
```
CARTO
174825750.000000 6837074250.000000 //left top corner
0 // zones
2069 2069 // size
1500.000000 1500.000000 // step
```

`Ech_noif Gaussf [image_in].tif [image_out].g2.tif x y`
`Ech_noif Gaussf Im_SPOT6.tif Im_SPOT6.g2.tif 2 3`

Pour lisser une image (filtre gaussien), `x`=déviation standard (p.ex. 2), `y` = paramètre de traitement des bords (1=noir, 3=mirroir)

## Découpage
**Decoupage**

`Decoupage Fsuperposable [adresse_orientation_orthoimage] [adresse_orientation_image_entrée] [adresse_image_entrée] [adresse_sauvegarde_image_sortie]`
`Decoupage Fsuperposable proba.ori ~/Documents/Classif_Sentinel2_5dates_Finistere/proba_L93.ori ~/Documents/Classif_Sentinel2_5dates_Finistere/proba_L93.tif proba_S2.tif`
Recalcule une image float superposable à l'orthoimage dont l'orientation est donnée en entrée 

Sauvegarder la partie de l’image S2 (`proba_L93.tif`) qui correspond à l’étendue de l’image SPOT6 en (décrite par `proba.ori`) dans `proba_S2.tif`.
`finistere1/test_41000_30000/classification_results/preds`

Outil alternatif: `/tools/raster_crop_resize.sh` (cf. `README.md`)

## Fusion
**FusProb** (contient aide)

Pour fusionner deux sources de données
`FusProb Fusion:[methode] proba_SPOT6_urbnonurb.tif proba_S2_urbnonurb.tif proba_fusion_DS_MasseSomme.tif`

# Classification, regions, morphological operators, détection de changement
**Pleiades** (contient aide)
`Pleiades Classer proba_fusion_DS_MasseSomme.tif classif_fusion_DS_MasseSomme.rle`
Pour classifier (maximum de la probabilité)

`Pleiades Pixels2Regions adresse_masque adresse_enregistrement_imagelabel`
Adresse masque binaire pour sortir une image raster avec des objets de pixels de la même classe adjacentes contenant un même identifiant (16 bit)

`Pleiades Pixels2RegionsInt adresse_masque adresse_enregistrement_imagelabel`
Adresse masque binaire pour sortir une image raster avec des objets de pixels de la même classe adjacentes contenant un même identifiant (32 bit, long format)

`Pleiades DetectionChangementBD bati_classif.tif bati_bd.tif bati_nouveau.tif bati_nouveau.rle bati_detruit.tif bati_detruit.rle 5`
Detecter le changement avec un fichier automatique, 5=taille d’érosion du contour de différence

`Pleiades PriorProb:f:c adresse_mesure xmin Pxmin xmax Pxmax adresse_enregistrement_proba`
Auréole de probabilité autour d'objets (`adresse_image_amorces`) dans en applicant une fonction linéaire allant de Pxmin (valeur) dans xmin (distance) à Pxmax dans xmax.

`Pleiades PriorProbFromAmorces adresse_image_amorces adresse_image_proba_amorces adresse_export_proba_finale [distance_max=200]`
Auréole de probabilité autour d'objets (`adresse_image_amorces`) en calculant la moyenne de leur probabilité d'appartenance à une classe (`adresse_image_proba_amorces`).

## gdal
**gdal_translate**

`gdal_translate  -b 1 -b 2 -b 3 -b 4 -b 1 $F1NAME.tif $F1NAME"_"doubleBat.tif`

Rérarranger des bandes d’un fichier, p.ex. copier la 1ère bande après la 5ème 

`gdal_translate -srcwin 0 1000 1000 1069 $FUSION_PROB.tif $FUSION_PROB\_crop_0_1000.tif`
Découper une image, par les paramètres `[xoffset yoffset xwidth ywidth fichier_in fichier_out]`

**gdal_mergy.py**
`gdal_merge.py -of GTiff -o $FILENAME_REASSEMBLED.tif $FILENAMES_CROP # regularization`
Merge geotiff files (`$_CROPFILENAMES`) in an output file `$FILENAME_REASSEMBLED`

## Fusion
**Classifieur**
Fusion par classification
`Classifieur EstimateModel --cc im_39000_40000,im_39000_42000,im_41000_30000,im_41000_40000,im_41000_42000 -d classification.train.datatype=labelimage -d classification.train.path=%s/train_tout.rle -d selectvtp.nbechantillonsmax=10000 -d canaux.path=%s/proba_S2.tif,%s/proba_SPOT6.tif -d classification.algorithm=opencv.rf -d classification.model.path=./fusion_classif/model_rf`

Fusion par classification : entraîner un modèle Random Forest sur la base de 1000 échantillons issus des images im_39000_40000/train_tout.rle etc.

**Regul**

`Regul IM_PROB.tif IM_PROB.tif im_HR.tif OUT_DIR/PREFIX $lambda $beta $gamma $epsilon $nbcanaux 5 $option_modele $option_lissage $option_multiplicatif`

Pour la régularisation, avec les paramètres en entrée probabilité de fusion (IM_PROB.tif), l’image utilisé pour le terme contraste (im_HR.tif), le préfixe des fichiers en output (OUT_DIR/PREFIX) et les paramètres de régularisation

**Bash2Make**

`touch bashtmp.sh` # parallelize: bash file with commands
```
for i in …;do
  echo -n "[some command to execute parallelized] ;" >> bashtmp.sh
  echo "[some command to execute parallelized] " >> bashtmp.sh
done
```
`Bash2Make bashtmp.sh makefiletmp # MakeFile compilation`
`make -f makefiletmp -j 8`
`rm makefiletmp bashtmp.sh`

Paralléliser des tâches en sauvegardant des commandes dans un fichier `bashtmp.sh`, puis l’exécuter avec Bash2Make en indiquant le nombre de cœurs à utiliser avec l’option `-j`. Utiliser `echo -n`  avec point-virgule (`;`)  à la fin pour exécuter plusieurs commandes dans un seul cœur.

## Evaluation
**Eval** (contient aide)

`Eval [classif_methode.rle] [gt.rle] bm.rle legende.txt cf.txt --Kappa --OA --AA --Fscore_moy`
Evaluer la classification par rapport à un fichier de vérité de terrain (`gt.rle`), save image of well / badly classified pixels in `bm.rle`, accuracy measures in `cf.txt`.

## Segmentation

**pyram** (contient aide)

`praym param.txt`
Faire la segmentation avec un fichier txt :
```
IMAGEFILE nom-du-fichier-image
[SOUSECH] facteur de sous-echantillonnage (defaut : 1)
[ALPHA] alpha-du-deriche (defaut : 1)
[VERBOSE] niveau-de-verbosite (defaut : 0)
[ISSFILE] nom-du-fichier-iss (defaut : pas de sauvegarde)
[MODESEVE] (images de labels compatibles avec le logicel Seve du SBV, defaut : 0)
CUTS valeur nom-du-fichier
[CUTS valeur nom-du-fichier]
[CUTS valeur nom-du-fichier]
```
**sxs**
Outil graphique pour visualiser la segmentation 
