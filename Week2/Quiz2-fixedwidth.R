con<-url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for")
fwk_dt<-data.table(read.fwf(file=con, widths=c(10,9,4,9,4,9,4,9,4), skip=4))
colnames(fwk_dt) 
print(fwk_dt[, sum(V4)])