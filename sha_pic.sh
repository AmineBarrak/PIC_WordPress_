#!/bin/bash

INPUT=$PWD/../sha_pic_res.csv
OUTPUT=$PWD/../res_sha_blank.csv

temprel=0

while IFS=',' read r1 r2 file pic
do
{
	if [ $temprel != $r2 ]; then
		git checkout $r2
	fi
	commit=$(git blame -L$pic,+1 -- $file | cut -c1-8)

	temprel=$r2
	echo "$r1,$r2,$file,$commit,$pic" >> $OUTPUT
}
done < "$INPUT"


