# Week3 q3

#Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
#Load the educational data from this data set:
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode. 
# How many of the IDs match? 
# Sort the data frame in descending order by GDP rank (so United States is last). 
# What is the 13th country in the resulting data frame?

#234 matches, 13th country is St. Kitts and Nevis
#234 matches, 13th country is Spain
#190 matches, 13th country is St. Kitts and Nevis
#189 matches, 13th country is St. Kitts and Nevis # Right answer for Q3
#190 matches, 13th country is Spain
#189 matches, 13th country is Spain

library(plyr)
library(dplyr)
library(Hmisc)


getFiles <- function () {
      if (!file.exists("GDP.csv")){
            download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",
                          destfile="GDP.csv")
      }
      
      if (!file.exists("EDSTATS_Country.csv")){
            download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",
                          destfile="EDSTATS_Country.csv")
      }
}

q345 <- function() {
      
      ##  Get the files downloaded if necessary
      
      getFiles()
      
      gdp<-tbl_df(read.csv(file="GDP.csv", skip=4, header=TRUE))  
      
      
      # Ranking is a factor column with a bunch of non-numeric values - it is important to convert factor to a
      # a character string first before doing the as.numeric conversion.  Learning:  Beware of numbers cast as factors
      # as.numeric will simply return ordinal number of factor level (which can be blank or some random string)
      
      gdp_sf <- gdp %>% select(X:X.4) %>% mutate(num_rank=suppressWarnings(as.numeric(as.character(X.1)))) %>% 
            filter(!is.na(num_rank))
      
      # 
      edstats <- tbl_df(read.csv(file="EDSTATS_Country.csv", header = TRUE)) 
      edstats_s<- edstats %>% select(CountryCode, Long.Name, Income.Group)
      
      ## Merge the two data sets
      
      m_df <- tbl_df(merge(x=gdp_sf, y=edstats_s, by.x = "X", by.y = "CountryCode"))
      m_df_s <- m_df  %>% arrange(desc(num_rank))  
      
      # Q3 answer
      
      print(m_df_s[13,]) 
      
      # Q4: What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
      
      
      q4_df<-tbl_df(ddply(m_df_s, .(Income.Group), summarise, mean_rank=mean(num_rank)))
      print(q4_df)
      
      # Q5: Cut the GDP ranking into 5 separate quantile groups. 
      # Make a table versus Income.Group. How many countries
      #are Lower middle income but among the 38 nations with highest GDP?
      
     m_df_sc<- m_df_s %>% mutate(rank_quartile=cut2(num_rank, g=5))
     print(table(m_df_sc$rank_quartile, m_df_sc$Income.Group))
      
}