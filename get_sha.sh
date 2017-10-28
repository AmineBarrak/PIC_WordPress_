#!/bin/bash

INPUT=$PWD/version-pairs-wordpress-20170315-pruned.csv
OUTPUT=$PWD/all_sha_rel_new.csv

way=1
	
#~ OLDIFS=$IFS

while IFS=',' read r1 r2
do
{
	git checkout $r2
	
	while read commit
	do
		echo "$r1,$r2,$commit" >> $OUTPUT
	done < <(git log --pretty=oneline $r1...$r2 | cut -c1-8)
	
	
	
	

way=$((way+1))
}
done < "$INPUT"

