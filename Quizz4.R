##
## Solutions for the Quizz 4 - Data Cleaning Course of Coursera
##
## Pedro A. Alonso Baigorri
##


##########################

# Question 1:
# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:

# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

# and load the data into R. The code book, describing the variable names is here:

# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Apply strsplit() to split all the names of the data frame on the characters "wgtp". What is the value of the 123 element of the resulting list?

##########################

setwd("D://Pedro//TID//BI4TD//DATA SCIENCE//COURSERA//Code//Data Cleaning")

if (!file.exists("./data")){dir.create("./data")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
fileName <- "./data/idaho_housing.csv"

download.file(fileUrl, fileName)

idahoH <- read.csv(fileName)

head(idahoH)
length(names(idahoH))

strsplit(names(idahoH), "wgtp")[[123]]


##########################

# Question 2:

# Load the Gross Domestic Product data for the 190 ranked countries in this data set:

# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?
# Original data sources:

# http://data.worldbank.org/data-catalog/GDP-ranking-table

##########################


setwd("D://Pedro//TID//BI4TD//DATA SCIENCE//COURSERA//Code//Data Cleaning")

if (!file.exists("./data")){dir.create("./data")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
fileName <- "./data/gdp190.csv"

download.file(fileUrl, fileName)

gdp190 <- read.csv(fileName)
gdp190 <- gdp190[5:194,]

names(gdp190)
head(gdp190)

#gdp colname is "X.3"
colnames(gdp190)[5] <- "gdp"

# remove the commas
gdp190$gdp <- gsub(",", "", gdp190$gdp)
head(gdp190)

gdp190$gdp <- as.numeric(gdp190$gdp)

# calculate the avg
library(dplyr)

#way1
summarize(gdp190, mean(gdp))

#way2
colSums(select(gdp190, gdp))/nrow(gdp190)


##########################

# Question 3:

# In the data set from Question 2 what is a regular expression that would allow you to count
# the number of countries whose name begins with "United"? 
# Assume that the variable with the country names in it is named countryNames. How many countries begin with United?

##########################

head(gdp190)
colnames(gdp190)[4] <- "countryNames"

countryNames <- gdp190$countryNames

countryNames[grep("*United",countryNames)]
countryNames[grep("United$",countryNames)]
countryNames[grep("^United",countryNames)]
countryNames[grep("^United",countryNames)]

##########################

# Question 4:
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
    
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Load the educational data from this data set:
    
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

# Match the data based on the country shortcode. 
# Of the countries for which the end of the fiscal year is available, how many end in June?

# Original data sources:
    
#    http://data.worldbank.org/data-catalog/GDP-ranking-table

#    http://data.worldbank.org/data-catalog/ed-stats

##########################

setwd("D://Pedro//TID//BI4TD//DATA SCIENCE//COURSERA//Code//Data Cleaning")

if (!file.exists("./data")){dir.create("./data")}

gdpURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
gdpName <- "./data/gdp.csv"

download.file(gdpURL, gdpName)

gdp <- read.csv(gdpName)
gdp <- gdp[5:194,]
colnames(gdp) <- c("country_short", "rank", "x.1", "country_long", "gdp", "x.4", "x.5", "x.6", "x.7", "x.8" )
head(gdp)


eduURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
eduName <- "./data/edu.csv"

download.file(eduURL, eduName)


edu <- read.csv(eduName)

head(edu)

merge_data <- merge(gdp, edu, by.x = "country_short", by.y = "CountryCode")
nrow(merge_data)
nrow(edu)
nrow(gdp)

colnames(merge_data)

t <- merge_data[grepl("Fiscal year end: June", merge_data$Special.Notes), "Special.Notes"]
t
length(t)

##########################

# Question 5:
# You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices for publicly traded companies on the NASDAQ and NYSE. 
# Use the following code to download data on Amazon's stock price and get the times the data was sampled.

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

# How many values were collected in 2012? How many values were collected on Mondays in 2012?

##########################
library(lubridate)

head(sampleTimes)
class(sampleTimes)

# getting year
# way 1
table(as.numeric(format(sampleTimes, "%Y")))
# way 2
length(grep("2012", format(sampleTimes, "%Y")))


## getting year & weekday
length(grep("2012 lu.", format(sampleTimes, "%Y %a")))

(table(year(sampleTimes), weekdays(sampleTimes)))

