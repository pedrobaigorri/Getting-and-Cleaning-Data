##
## Solutions for the Quizz 2 - Data Cleaning Course of Coursera
##
## Pedro A. Alonso Baigorri
##

# -----------------------------------
# QUIZZ 1

# Register an application with the Github API here https://github.com/settings/applications. 
# Access the API to get information on your instructors repositories
# (hint: this is the url you want "https://api.github.com/users/jtleek/repos").
# Use this data to find the time that the datasharing repo was created. What time was it created?

# This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 

# You may also need to run the code in the base R package and not R studio.

library(httr)
library(jsonlite)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "10cbec594ab90bb21ac3",
                   secret = "4ed11b312b975764d47eb6784674acbab6093697")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
json1 <- content(req)
json2 <- jsonlite::fromJSON(toJSON(json1))

names(json2)
datasharing <- json2[which(json2$name=="datasharing"),]
datasharing$created_at

#ANSWER: [1] "2013-11-07T13:25:07Z"


# --------------------------------------------
# The sqldf package allows for execution of SQL commands on R data frames. 
# We will use the sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL.

# Download the American Community Survey data and load it into an R object called acs
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

# Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?

library(sqldf)

setwd("D://Pedro//TID//BI4TD//DATA SCIENCE//COURSERA//Code//Data Cleaning//data")

file <- "getdata_data_Fss06pid.csv"

acs <- read.csv(file)

sqldf("select pwgtp1 from acs where AGEP < 50")


# Using the same data frame you created in the previous problem, what is the equivalent function to unique(acs$AGEP)
unique(acs$AGEP)
sqldf("select distinct AGEP from acs")

# --------------------------------------------
# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
    
# http://biostat.jhsph.edu/~jleek/contact.html

# (Hint: the nchar() function in R may be helpful)

library(httr)

url <- "http://biostat.jhsph.edu/~jleek/contact.html"

nchar(readLines(url, 10))[10]
nchar(readLines(url, 20))[20]
nchar(readLines(url, 30))[30]
nchar(readLines(url, 100))[100]


#---------------------------------------------
#Read this data set into R and report the sum of the numbers in the fourth of the nine columns.

#https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for

#Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for

#(Hint this is a fixed width file format)

library(httr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
html <- GET(url)
content <- content(html, as="text")
lines <- readLines(url)
l <- length(lines)

#elimino las lineas de cabecera
lines <- lines[5:l]
write.table(lines, "temp", row.names = FALSE, col.names = FALSE)

# me quedo con la columna solo que me interesa, son 4 caracteres a partir del 29.
r <- read.fwf("temp", widths = c(-29,4), col.names = c("t"))
colSums(r)
