#!/bin/bash

INPUT=$PWD/final_pic_uniq.csv
OUTPUT=$PWD/final_pic_checked.csv

way=1
	
#~ OLDIFS=$IFS
git checkout 2.0
temporel=0
while IFS=',' read r1 r2 commit freq pic
do
{
	if [ $temprel != $r2 ]; then
			git checkout $r2
			date_R1=$(git show $r1 -s --format=%ci | cut -c -19)
			date_R2=$(git show $r2 -s --format=%ci | cut -c -19)
			date_s_r1=$(date --date=$date_R1 +%s)
			date_s_r2=$(date --date=$date_R2 +%s)
	fi
	
	
	date_commit=$(git show -s --format=%ci $commit)
	date_s_commit=$(date --date=$date_commit +%s)
	if [ ${date_s_commit} -ge ${date_s_r1} ] &&  [ ${date_s_commit} -le ${date_s_r1} ]; then
		echo "it is ok"
	  echo "$r1,$r2,$commit,$freq,$pic"  >> $OUTPUT
	fi
	

	temprel=$r2
	
}
done < "$INPUT"
