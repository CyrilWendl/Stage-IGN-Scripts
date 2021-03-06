DIR_OUT=/media/cyrilwendl/15BA65E227EC1B23/gironde/Data/Classif_Sentinel-2	# classification directory
DIR_BASH=/home/cyrilwendl/DeveloppementBase/Scripts 						# bash scripts directory
DIR_GT=/media/cyrilwendl/15BA65E227EC1B23/gironde/Data/BDTOPO				# ground truth directory
DIR_EXES=/home/cyrilwendl/DeveloppementBase/exes							# executables directory

cd $DIR_OUT
#get file names of bands
BANDS=""
for i in 20*/; do
	cd $DIR_OUT/$i
	for j in 2 3 4 5 6 7 8 8A 11 12; do
		BANDS="$BANDS${i}B$j.tif,"
	done
done
BANDS=${BANDS%?} # remove trailing comma
echo $BANDS

cd $DIR_OUT

#50000 echantillons
~/DeveloppementBase/exes/Classifieur SelectVTP -d classification.train.datatype=labelimage -d classification.train.path=train_tout.rle -d selectvtp.nbechantillonsmax=50000 -d canaux.path=$BANDS -d selectvtp.output.path=train_50000.vtp

~/DeveloppementBase/exes/Classifieur EstimateModel -d classification.algorithm=opencv.rf -d classification.train.path=train_50000.vtp -d classification.model.path=model_rf_50000

~/DeveloppementBase/exes/Classifieur Classify -d classification.model.path=model_rf_50000 -d canaux.path=$BANDS -d classification.output.path=classif_rf_50000.rle -d global.mode_big=true -d global.pas_dallage=2000 -d global.verbose=true -d classification.output.proba.path=appart_rf_50000.tif -d classification.save.proba=true

export DIR_RAM=/home/cyrilwendl/Documents/tmp # Temporary directory for work in RAM
sudo umount $DIR_RAM # allocate RAM memory
rm -Rf $DIR_RAM
mkdir $DIR_RAM
sudo mount -t tmpfs -o size=4g tmpfs $DIR_RAM # allocate RAM memory
for file in appart_rf_50000.tif appart_rf_50000.tfw;do
	cp  $file $DIR_RAM/$file
done
gdalwarp -multi -s_srs EPSG:32630 -t_srs EPSG:2154 $DIR_RAM/appart_rf_50000.tif $DIR_RAM/appart_rf_50000_L93.tif


