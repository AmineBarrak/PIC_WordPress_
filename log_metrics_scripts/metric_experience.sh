#!/bin/bash

INPUT=$PWD/only_commits.csv
OUTPUT=$PWD/experience.csv

#~ OLDIFS=$IFS
#~ git checkout 
while IFS=',' read r1 r2 commit
do
{
	
	#~ if [ $temprel != $r2 ]; then
		#~ git checkout $r2
	#~ fi
	#~ echo $commit
	date_commit=$(git show -s --format=%ci $commit | cut -c -19)

	#~ echo $date_commit
		
	author=$(git show $commit | grep "Author: " | tr ' ' '\n' | grep -v "Author:" | head -n 1)
	#~ echo $author
	author_experience=$(git log --before="$date_commit" --oneline --author="$author" | wc -l)
	#~ echo $author_experience
	#~ temprel=$r2
	echo "$r1,$r2,$commit,$author_experience">>$OUTPUT
	
	
}
done < "$INPUT"
