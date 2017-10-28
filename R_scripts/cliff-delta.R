#install.packages("faraway")
#install.packages("effsize")
require(faraway)
require(effsize)
data<-read.csv("/home-students/ambard/collect_commits_all_final.csv", header = TRUE)
data_ref<-data
#data_ref$sic_lines<-NULL
data_ref$r1<-NULL
data_ref$r2<-NULL
data_ref$commit<-NULL
#data_ref$file<-NULL
has_sic <- data_ref[data_ref[,'pic']==1,]
has_no_sic <- data_ref[data_ref[,'pic']==0,]
print("author_experience")
cliff.delta(has_sic[,"author_experience"], has_no_sic[,"author_experience"],return.dm=TRUE)
