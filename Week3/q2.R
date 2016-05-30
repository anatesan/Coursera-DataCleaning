# Week3-q2.R

#Using the jpeg package read in the following picture of your instructor into R
#https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
#Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? (some Linux systems may produce an answer 638 different for the 30th quantile)

#-10904118 -10575416
#-15259150 -10575416  [RIGHT answer]
#10904118 -594524
#-16776430 -15390165

library(jpeg)

q2 <- function() {
      
      if (!file.exists("jeff.jpg")) {
            download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", 
                          destfile = "jeff.jpg", mode = "wb")
      }
      jp <-readJPEG("jeff.jpg", native=TRUE)
      q_jp<-quantile(jp, probs=c(0.30, 0.8, 0, 1))
      print(q_jp)
}