library(sqldf)

download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", destfile="Fss06pid.csv" )
acs <- read.csv("Fss06pid.csv")

# sqldf command in quiz

sqldf("select count(pwgtp1) from acs where AGEP < 50")
sqldf("select distinct AGEP from acs")