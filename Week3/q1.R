library(dplyr)

q1<-function() {

      ## download file

      if (!file.exists("Fss06hid.csv")) {
            Qurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
            download.file(url, destfile="Fss06hid.csv")
      }
      
      t_df<-tbl_df(read.csv(file="Fss06hid.csv", header = TRUE))
      
      test_v<- t_df %>% mutate(test_vec=(ACR==3 &AGS==6)) %>% select(test_vec)
      agricultureLogical <- test_v$test_vec
      
      head(which(agricultureLogical), 3)



}