cd /media/cyrilwendl/15BA65E227EC1B23/finistere/detail/im_41000_30000/Binary/Temp

rm -rf *.jpg

# 1. image with buildings: bati.tif
convert bati.tif -set colorspace RGB -colorize 255,0,0 -negate -transparent white bati.png
convert bati.png binary_1_bati.jpg

# 2. distance image
gdal_contrast_stretch -percentile-range 0.02 0.98 dist.tif dist_stretched.tif
convert dist_stretched.tif binary_2_dist.jpg

# 3. overlay 1. and 2.
composite -blend 50% bati.png dist_stretched.tif binary_3_bati-dist.jpg

# 4. probability
gdal_translate -ot Float32 proba_regul_urbain.tif proba_regul_urbain_2.tif
convert proba_regul_urbain_2.tif binary_4_proba_regul_urbain.jpg

rm *.xml
