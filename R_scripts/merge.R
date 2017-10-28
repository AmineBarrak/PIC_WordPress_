


####################merge final########################
data1<-read.csv("/home/amine/pic_releases/final/all.csv", header = TRUE)
data2<-read.csv("/home/amine/pic_releases/final/collect_commits_all_final.csv", header = TRUE)
temp3<-merge(data1, data2 ,by = c('r1','r2','commit'))

temp3[["freq"]][is.na(temp3[["freq"]])] <- 0
temp3[["pic"]][is.na(temp3[["pic"]])] <- 0

write.csv(temp3,'/home/amine/pic_releases/final/collect_commits_all_final.csv', row.names =FALSE)

