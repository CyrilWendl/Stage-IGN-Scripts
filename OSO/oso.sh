# Convert OSO to GT labels
DIR_OSO=/media/cyrilwendl/Data/OSO
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts


cd $DIR_OSO

rm -rf $DIR_OSO
mkdir -p $DIR_OSO

Legende label2masqueunique $DIR_BASH/legende.txt $DIR_OSO/.tif 3 4 5 masktmp/nonurbain.tif
> Legende masques2label legende.txt mask/ labels.rle
# convert labels: 
# bati: [41 42 43]
# foret: [31 32]
# eau: [51 53]
# vegetation autre: [11 12 34 36 211 221 222]
# route: [44 45 46]
OCS_2016_CESBIO
