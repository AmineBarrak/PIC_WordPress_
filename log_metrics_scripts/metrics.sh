#!/bin/bash

INPUT=$PWD/collect_all_rel.csv
OUTPUT=$PWD/metrics.csv

echo "r1,r2,freq,pic,msg_size,author_experience,nbr_insert_line_commit,nbr_deleted_line_commit,nbr_churn_file_commit,week_day,month_day,month">>$OUTPUT

#~ OLDIFS=$IFS
git checkout 2.0.1
while IFS=',' read r1 r2 commit freq pic
do
{
	
	if [ $temprel != $r2 ]; then
		git checkout $r2
	fi
	


	
		
	msg_size=$(git log --format=%B -n 1 $commit | grep -v "^Built from\|^git-svn-id"|wc -w)
	author=$(git show $commit | grep "Author: " | tr ' ' '\n' | grep -v "Author:" | head -n 1)
	author_experience=$(git log --oneline --author=$author | wc -l)
	
	nbr_insert_line_commit=$(git show  $commit --shortstat | tail -1 | sed -e 's/,\+/\n/g' | grep "insertion" | sed -r 's/.* ([0-9]*) .*/\1/g')
	nbr_deleted_line_commit=$(git show  $commit --shortstat | tail -1 | sed -e 's/,\+/\n/g' | grep "deletion" | sed -r 's/.* ([0-9]*) .*/\1/g')
	
	nbr_churn_file_commit=$(git show  $commit --shortstat | tail -1 | sed -e 's/,\+/\n/g' | grep "file" | sed -r 's/.* ([0-9]*) .*/\1/g')
	
	week_day=$(git show -s --format=%cd  $commit |awk '{print $1}')
	month_day=$(git show -s --format=%cd  $commit| awk '{print $3}')
	month=$(git show -s --format=%cd  $commit |awk '{print $2}')
	
	if [ -z "$nbr_insert_line_commit" ]; then
			nbr_insert_line_commit=0
	fi	
	if [ -z "$nbr_deleted_line_commit" ]; then
			nbr_deleted_line_commit=0
	fi
	if [ -z "$nbr_churn_file_commit" ]; then
			nbr_churn_file_commit=0
	fi
	if [ -z "$msg_size" ]; then
			msg_size=0
	fi
	temprel=$r2
	echo "$r1,$r2,$freq,$pic,$msg_size,$author_experience,$nbr_insert_line_commit,$nbr_deleted_line_commit,$nbr_churn_file_commit,$week_day,$month_day,$month">>$OUTPUT

	
}
done < "$INPUT"
