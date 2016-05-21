##microbenchmark(## {rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]}, 

trial_count<-1000

cat(sprintf("%15s: %10.0f\n", "Trial Count", trial_count))

sapply_res<- replicate(trial_count, unname(system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))))
sapply_mean <- mean(sapply_res[1, sapply_res[1,]>0])
cat(sprintf("%15s:%10f\n", "sapply mean", sapply_mean))

#mean_2_res<- replicate(trial_count, unname(system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})))
#mean_2_mean <- mean(mean_2_res[1, mean_2_res[1,]>0])
#cat(sprintf("mean_2_mean :%f\n", mean_2_mean))



#DT_res<- replicate(trial_count, unname(system.time(DT[,mean(pwgtp15),by=SEX])))
#DT_mean <- mean(DT_res[1,DT_res[1,]>0])
#cat(sprintf("DT_mean :%f\n", DT_mean))

tapply_res<- replicate(trial_count, unname(system.time(tapply(DT$pwgtp15,DT$SEX,mean))))
tapply_mean <- mean (tapply_res[1, tapply_res[1,]>0])
cat(sprintf("%15s:%10f\n", "tapply_mean", tapply_mean))

#mean_res<- replicate(trial_count, unname(system.time(mean(DT$pwgtp15,by=DT$SEX))))
#mean_mean <- mean (mean_res[1,mean_res[1,]>0])
#cat(sprintf("mean_mean :%f\n", mean_mean))











