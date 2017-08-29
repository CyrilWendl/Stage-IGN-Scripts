# gironde
cd /media/cyrilwendl/15BA65E227EC1B23/gironde/data/SPOT6_gironde/proba
x=$(ls | cut -d_ -f2-3)
tiles=""
for e in $x; do
	inx=$(echo $e | cut -d_ -f1| awk '$0 < 40500') # y value	
	iny=$(echo $e | cut -d_ -f2| awk '$0 > 10500') # y value	
	if [ ! -z $inx ] && [ ! -z $iny ]; 
		then
		tiles="$tiles$e "
	fi
done
echo $tiles

# get extent
# mkdir -p extent
# tilenames="";for i in $tiles; do tilenames=$tilenames"classif_$i.tif ";done
# gdaltindex extent/spot6.shp $tilenames

# overlapping tiles: 340 for gironde, 72 for finistere
