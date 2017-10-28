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
		MaxNestings=0
		CountDeclFunctions=0
		Cyclomatics=0
		CountLineCodes=0
		CountStmtDecls=0
		CountLineBlank_Phps=0
		RatioCommentToCodes=0
		ratio=0
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
			
				MaxNestings=$((MaxNestings + $MaxNesting))
				CountDeclFunctions=$((CountDeclFunctions + $CountDeclFunction))
				Cyclomatics=$((Cyclomatics + $Cyclomatic))
				CountLineCodes=$((CountLineCodes + $CountLineCode))
				CountStmtDecls=$((CountStmtDecls + $CountStmtDecl))
				CountLineBlank_Phps=$((CountLineBlank_Phps + $CountLineBlank_Php))
				#RatioCommentToCodes=$((RatioCommentToCodes + $RatioCommentToCode))
				RatioCommentToCodes=$(echo "$RatioCommentToCodes + $RatioCommentToCode" | bc)
				ratio=$((ratio+1))
				echo "debut ratio $ratio"
			done < "/home-students/ambard/und_pic/folder9/output_und/test.csv"
			echo "end ratio $ratio"
			if [ "$ratio" -eq "0" ]; then
				MaxNestings=0
				CountDeclFunctions=0
				Cyclomatics=0
				CountLineCodes=0
				CountStmtDecls=0
				CountLineBlank_Phps=0
				#RatioCommentToCodes=$((RatioCommentToCodes/ratio))
				RatioCommentToCodes=0
			else
				MaxNestings=$((MaxNestings/ratio))
				CountDeclFunctions=$((CountDeclFunctions/ratio))
				Cyclomatics=$((Cyclomatics/ratio))
				CountLineCodes=$((CountLineCodes/ratio))
				CountStmtDecls=$((CountStmtDecls/ratio))
				CountLineBlank_Phps=$((CountLineBlank_Phps/ratio))
				#RatioCommentToCodes=$((RatioCommentToCodes/ratio))
				RatioCommentToCodes=$(awk "BEGIN {printf \"%.2f\",${RatioCommentToCodes}/${ratio}}")
			fi
		fi
		
	echo "$r1,$r2,$commit,$MaxNestings,$CountDeclFunctions,$Cyclomatics,$CountLineCodes,$CountStmtDecls,$CountLineBlank_Phps,$RatioCommentToCodes" >> $OUTPUT
		
}
done < $INPUT
