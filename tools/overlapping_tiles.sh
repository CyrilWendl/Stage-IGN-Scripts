# get overlapping tile numbers (visually based) and save shp file of extent

REGION=$1
cd /media/cyrilwendl/15BA65E227EC1B23/$REGION/data/SPOT6_$REGION/proba
if [ $REGION = "gironde" ];
	then
	xmin=14500 # minimum and maximum of tile number
	xmax=38500
	ymin=12500
	date=20170419
	x=$(ls | cut -d_ -f2-3)
elif [ $REGION = "finistere" ];
	then
	xmin=30000
	xmax=43000
	ymin=20000
	date=20170525
	x=$(ls | grep -E '[0-9]{2}[0]{3}' |cut -d_ -f2-3)
else
	exit
fi

tiles=""
for e in $x; do
	inx_min=$(echo $e | cut -d_ -f1| awk -v lim="$xmin" '$0 > lim') # x value	
	inx_max=$(echo $e | cut -d_ -f1| awk -v lim="$xmax" '$0 < lim') # x value
	iny_min=$(echo $e | cut -d_ -f2| awk -v lim="$ymin" '$0 > lim') # y value
	if [ ! -z $inx_min ] && [ ! -z $inx_max ] && [ ! -z $iny_min ] ;
		then
		tiles="$tiles$e "
	fi
done
echo $tiles
exit

#x=$(bash ~/DeveloppementBase/Scripts/overlapping_tiles.sh)

# number of overlapping tiles
i=0; 
for tile in $tiles; do
	let "i++"
done
echo "Number of overlapping tiles: $i"

# get extent
cd ../classif
tilenames="";
for i in $tiles; do 
  tilenames=$tilenames$(pwd)"/classif_$i.tif ";
done
cd ../../	
mkdir -p extent
rm -rf extent/spot6*
gdaltindex extent/spot6.shp $tilenames > /dev/null
gdaltindex extent/s2.shp S2_$REGION/$date/B2.tif > /dev/null

 #overlapping tiles: 340 for gironde, 72 for finistere
