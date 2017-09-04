# Convert OSO to GT labels
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
DIR_EXES=$DIR_BASH/exes
DIR_OSO=/media/cyrilwendl/15BA65E227EC1B23/data/OSO
DATA_OSO=/media/cyrilwendl/15BA65E227EC1B23/data/OSO/OCS_2016_CESBIO.tif

rm -rf $DIR_OSO/masktmp
mkdir -p $DIR_OSO/masktmp
cd $DIR_OSO/masktmp

# convert labels
$DIR_EXES/Legende label2masqueunique $DIR_OSO/nomenclature_oso.txt $DATA_OSO 41 42 43 masktmp/bati.tif
$DIR_EXES/Legende label2masqueunique $DIR_OSO/nomenclature_oso.txt $DATA_OSO 31 32 masktmp/vegetation_foret.tif
$DIR_EXES/Legende label2masqueunique $DIR_OSO/nomenclature_oso.txt $DATA_OSO 51 53 masktmp/eau.tif
$DIR_EXES/Legende label2masqueunique $DIR_OSO/nomenclature_oso.txt $DATA_OSO 11 12 34 36 211 221 222 masktmp/vegetation_autre.tif
$DIR_EXES/Legende label2masqueunique $DIR_OSO/nomenclature_oso.txt $DATA_OSO 44 45 46 masktmp/route.tif

# merge labels
$DIR_EXES/Legende masques2label legende.txt mask/ labels.rle

