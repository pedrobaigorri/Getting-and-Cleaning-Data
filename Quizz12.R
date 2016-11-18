##
## Solutions for the Quizz 1 - Data Cleaning Course of Coursera
##
## Pedro A. Alonso Baigorri
##


## Question 1. 
## The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
    
##    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

## and load the data into R. The code book, describing the variable names is here:
    
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

## How many properties are worth $1,000,000 or more?

library(data.table)

setwd("D://Pedro//TID//BI4TD//DATA SCIENCE//COURSERA//Code//Data Cleaning//data")

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

download.file(fileURL, "us_communities.csv")

us_comm_dt <- fread("us_communities.csv")

nrow(us_comm_dt[us_comm_dt$VAL == 24, ])

us_comm_dt[, .N, by=FES]


# Question 3. 
# Download the Excel spreadsheet on Natural Gas Aquisition Program here:
#
#  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
#
# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called: dat
# What is the value of:  sum(dat$Zip*dat$Ext,na.rm=T)

library(xlsx)

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

download.file(fileURL, "NGAP_v4.xlsx", method="internal")

row_index <- 18:23
col_index <- 7:15

dat <- read.xlsx("NGAP_v3.xlsx", sheetIndex = 1, header=TRUE, colIndex = col_index, rowIndex = row_index)

sum(dat$Zip*dat$Ext,na.rm=T)

# Question 4
# Read the XML data on Baltimore restaurants from here:
#    
#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
#
# How many restaurants have zipcode 21231?

library(XML)

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
download.file(fileURL, "restaurants.xml", method="internal")

doc <- xmlTreeParse("restaurants.xml", useInternalNodes = TRUE)

zipcodes <- xpathSApply(doc, "//zipcode", xmlValue)
length(zipcodes[zipcodes == 21231])

# Question 5
# The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
    
# Https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

# using the fread() command load the data into an R object

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

download.file(fileURL, "idaho.csv")

DT <- fread("idaho.csv")


system.time(apply(split(DT$pwgtp15,DT$SEX),mean))

# This is the faster solution
system.time(DT[,mean(pwgtp15),by=SEX])

system.time(tapply(DT$pwgtp15,DT$SEX,mean))

system.time(mean(DT[DT$SEX==1,]$pwgtp15))
system.time(mean(DT[DT$SEX==2,]$pwgtp15))

system.time(rowMeans(DT)[DT$SEX==1])
system.time (rowMeans(DT)[DT$SEX==2])

system.time(mean(DT$pwgtp15,by=DT$SEX))


