##
## Some examples from demo in week 3 dplyr
##
##
## Pedro A. Alonso Baigorri

library(dplyr)

setwd("D://Pedro//TID//BI4TD//DATA SCIENCE//COURSERA//Code//Data Cleaning//data")

chicago <- readRDS("chicago.rds")
head(chicago)

#select
head(select(chicago, 1:5))
head(select(chicago, -(city:dptp)))

#filter
chic.f <- filter(chicago, pm25tmean2 > 30)
head(select(chic.f, 1:3, pm25tmean2), 10)

chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
head(select(chic.f, 1:3, pm25tmean2, tmpd), 10)

#arrange
chicago <- arrange(chicago, date)
head(select(chicago, date, pm25tmean2), 3)
tail(select(chicago, date, pm25tmean2), 3)

#rename
chicago <- rename(chicago, dewpoint = dptp, pm25 = pm25tmean2)
head(chicago[, 1:5], 3)

#mutate
chicago <- mutate(chicago, pm25detrend=pm25-mean(pm25, na.rm=TRUE))
head(select(chicago, pm25, pm25detrend))

#group by
chicago <- mutate(chicago, tempcat = factor(1 * (tmpd > 80),labels = c("cold", "hot")))
head(filter(chicago, tmpd > 80))
head(filter(chicago, tmpd < 80))

hotcold <- group_by(chicago, tempcat)
head(hotcold)
tail(hotcold)
head(chicago)

#summarize
summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE),
          o3 = max(o3tmean2),
          no2 = median(no2tmean2))

#%>%
chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% summarize(pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2, na.rm = TRUE), no2 = median(no2tmean2, na.rm = TRUE))
                  
     
     

