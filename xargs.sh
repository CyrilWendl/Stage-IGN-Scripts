REGION=gironde
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts
tiles=($(bash $DIR_BASH/overlapping_tiles.sh $REGION))

cd /media/cyrilwendl/15BA65E227EC1B23/
rm -rf tmp.sh;
touch tmp.sh

for i in ${tiles[@]}; do 
	echo "bash ~/DeveloppementBase/Scripts/fusion_regul_all/master.sh $REGION $i" >> tmp.sh
#	echo "bash ~/DeveloppementBase/Scripts/fusion_regul_all/segmentation.sh $i" >> tmp.sh	
#	echo "bash ~/DeveloppementBase/Scripts/fusion_regul_all/regularize.sh /media/cyrilwendl/15BA65E227EC1B23/fusion/im_$i" >> tmp.sh

done

cat tmp.sh | while read i; do printf "%q\n" "$i"; done | xargs --max-procs=1 -I CMD bash -c CMD
rm tmp.sh

