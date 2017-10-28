#!/bin/bash
INPUT=$PWD/../res.csv
OUTPUT=$PWD/../res_und.csv
OUTPUT_UND=$PWD/../output_und/und_cmd.txt
way=1
OLDIFS=$IFS
IFS=" "


while IFS=',' read  r1 r2 commit freq pic
do
{

	
		echo "$r1 $r2 $commit $is_fix"
		git checkout $commit
		MaxNesting=0
		CountDeclFunction=0
		Cyclomatic=0
		CountLineCode=0
		CountStmtDecl=0
		CountLineBlank_Php=0
		RatioCommentToCode=0
		
		check=$(git diff-tree --no-commit-id --name-only -r $commit)
		if [ -z "$check" ] || [[ $check != *".php"* ]]; then
		#if [ -z "$check" ]; then
			echo "vide"
			
		else


			rm -f ../output_und/project.udb ../output_und/und_cmd.txt ../output_und/metrics.csv
		
			echo "und create -languages web /home-students/ambard/und_pic/folder9/output_und/project.udb" > $OUTPUT_UND
			while read file_commit
			do
				echo $file_commit
				if [[ $file_commit == *".php" ]]; then
					add_und="und add $PWD/$file_commit"
					echo $add_und >> $OUTPUT_UND
				fi
			
			done < <(git diff-tree --no-commit-id --name-only -r $commit)
			echo "und settings -reportOutputDirectory /home-students/ambard/und_pic/folder9/output_und /home-students/ambard/und_pic/folder9/output_und/project.udb" >> $OUTPUT_UND
			echo "und settings -metricsOutputFile /home-students/ambard/und_pic/folder9/output_und/metrics.csv /home-students/ambard/und_pic/folder9/output_und/project.udb" >> $OUTPUT_UND
			echo "und settings -metricsFileNameDisplayMode RelativePath" >> $OUTPUT_UND
			echo "und settings -metrics MaxNesting CountDeclFunction Cyclomatic CountLineCode CountStmtDecl CountLineBlank_Php RatioCommentToCode /home-students/ambard/und_pic/folder9/output_und/project.udb" >> $OUTPUT_UND
			echo "und analyze /home-students/ambard/und_pic/folder9/output_und/project.udb" >> $OUTPUT_UND
			echo "und metrics /home-students/ambard/und_pic/folder9/output_und/project.udb" >> $OUTPUT_UND
		
			/home-students/ambard/und_pic/folder9/bin/linux64/und $OUTPUT_UND
		


			cat /home-students/ambard/und_pic/folder9/output_und/metrics.csv | grep -E '^File' > /home-students/ambard/und_pic/folder9/output_und/test.csv
			while IFS=',' read  Kind Name MaxNesting CountDeclFunction Cyclomatic CountLineCode CountStmtDecl CountLineBlank_Php RatioCommentToCode
			do 
				echo "$r1,$r2,$commit,$MaxNesting,$CountDeclFunction,$Cyclomatic,$CountLineCode,$CountStmtDecl,$CountLineBlank_Php,$RatioCommentToCode" >> $OUTPUT
			
			done < "/home-students/ambard/und_pic/folder9/output_und/test.csv"
		
		fi
		
		
}
done < $INPUT
