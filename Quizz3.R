##
## Solutions for the Quizz 3 - Data Cleaning Course of Coursera
##
## Pedro A. Alonso Baigorri
##

## QUESTION 1
#
# the American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
    
#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

# and load the data into R. The code book, describing the variable names is here:
    
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of agriculture products. 
# Assign that logical vector to the variable agricultureLogical. Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.

# which(agricultureLogical)

# What are the first 3 values that result?


setwd("D://Pedro//TID//BI4TD//DATA SCIENCE//COURSERA//Code//Data Cleaning//data")

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

download.file(fileURL, "us_communities.csv")

comms_df <- read.csv("us_communities.csv")

comms_df2 <- filter(comms_df, AGS == 6 & ACR == 3)

agricultureLogical <- comms_df$AGS == 6 & comms_df$ACR == 3
which(agricultureLogical)[1:3]

# Question 2
# Using the jpeg package read in the following picture of your instructor into R

# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg

# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
# (some Linux systems may produce an answer 638 different for the 30th quantile)

library(jpeg)

setwd("D://Pedro//TID//BI4TD//DATA SCIENCE//COURSERA//Code//Data Cleaning//data")

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
jpgName <- "Fjeff.jpg"

download.file(fileURL, jpgName , mode ="wb")

img <- readJPEG(jpgName, native = TRUE)

quantile(img, probs = c(0.3, 0.8))

# Question 3
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
    
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Load the educational data from this data set:
    
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

# Match the data based on the country shortcode. 
# How many of the IDs match? 
# Sort the data frame in descending order by GDP rank (so United States is last). 
# What is the 13th country in the resulting data frame?

# Original data sources:
    

# http://data.worldbank.org/data-catalog/GDP-ranking-table

# http://data.worldbank.org/data-catalog/ed-stats

setwd("D://Pedro//TID//BI4TD//DATA SCIENCE//COURSERA//Code//Data Cleaning//data")

gdpURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
gdpName <- "gdp.csv"

download.file(gdpURL, gdpName)

gdp <- read.csv(gdpName)
gdp <- gdp[5:194,]
colnames(gdp) <- c("country_short", "rank", "x.1", "country_long", "gdp", "x.2", "x.3", "x.4", "x.5", "x.6" )
gdp <- select(gdp, country_short, rank, gdp)

head(gdp)


eduURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
eduName <- "Edu.csv"

download.file(eduURL, eduName)

edu <- read.csv(eduName)

head(edu)

merge_data <- merge(gdp, edu, by.x = "country_short", by.y = "CountryCode")
nrow(merge_data)
nrow(edu)
nrow(gdp)
merge_data$rank <- as.numeric(merge_data$rank)

merge_data <- arrange(merge_data, desc(rank))
merge_data[13, "Short.Name"]

# Question 4
# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
grouped <- group_by(merge_data, Income.Group)
summarize(grouped, rank_mean = mean(rank))
head(grouped)

# Question 5
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries
# are Lower middle income but among the 38 nations with highest GDP?

# way 1
merge_data$rank_q <- cut(merge_data$rank, breaks=quantile(merge_data$rank, c(0, 0.2, 0.4, 0.6, 0.8, 1)))
table(merge_data$Income.Group, merge_data$rank_q)

# way 2
library(Hmisc)
merge_data$rank_q <- cut2(merge_data$rank, g=5)
table(merge_data$Income.Group, merge_data$rank_q)

# way 3
merge_data$top_38 <- ifelse(merge_data$rank > 38, FALSE, TRUE)
table(merge_data$Income.Group, merge_data$top_38)

# some tests
merge_data[merge_data$rank_q == "(1,38.6]", "rank"]
merge_data[merge_data$top_38 == TRUE, "rank"]
nrow(merge_data)
merge_data$rank

