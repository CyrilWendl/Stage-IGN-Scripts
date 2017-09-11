#!/usr/bin/env bash
# will yield 0 if regularization has not converged (all values the same) and 1 otherwise.

FILE=$(ls $1/regul*_0.tif)

if [ ! -f $FILE ]
	then
	echo 0
	exit
fi

RANGE=$(gdalinfo -mm $FILE |grep 'Min/Max'|cut -d "=" -f2- |sed 's/,/ /g')

numCompare() {
   awk -v n1="$1" -v n2="$2" 'BEGIN {printf "%s " (n1<n2?"<":">=") " %s\n", n1, n2}'
}

j="2.000"
diff=0
for i in $RANGE; do
	di=$(echo $i'>'$j | bc -l)
	dj=$(echo $i'<'$j | bc -l)
	if [ "$di" !=  0 ] || [ "$dj" !=  0 ] ; then
		diff=1
	fi
done
echo $diff
