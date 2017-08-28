cd /media/cyrilwendl/Data/Images_SPOT6_finistere
tiles=($(ls | awk '(substr($1, 6, 5) >= 30000) && (substr($1, 12, 5) > 20000) && (substr($1, 6, 5) < 43000)' | awk '{print substr($0,6,11)}' | grep -E '[0-9]{2}[0]{3}'))

cd /media/cyrilwendl/15BA65E227EC1B23/
rm -rf tmp.sh;
touch tmp.sh

for i in ${tiles[@]}; do 
#	echo "bash ~/DeveloppementBase/Scripts/fusion_regul_all/master.sh $i" >> tmp.sh
	echo "bash ~/DeveloppementBase/Scripts/fusion_regul_all/segmentation.sh $i" >> tmp.sh	
#	echo "bash ~/DeveloppementBase/Scripts/fusion_regul_all/regularize.sh /media/cyrilwendl/15BA65E227EC1B23/fusion/im_$i" >> tmp.sh
done

cat tmp.sh | while read i; do printf "%q\n" "$i"; done | xargs --max-procs=16 -I CMD bash -c CMD
rm tmp.sh

