library (reshape2)
head(mtcars)
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp"))

head(carMelt)
tail(carMelt)

cylData <- dcast(carMelt, cyl ~ variable, mean)
cylData

head(InsectSprays)
class(InsectSprays$count)

tapply(InsectSprays$count, InsectSprays$spray, sum)

spIns <- split(InsectSprays$count, InsectSprays$spray)
spIns

sprCount <- lapply(spIns, sum)
sprCount

unlist(sprCount)

s <- sapply(spIns, sum)
spIns

s <- as.data.frame(s)
head(s)
s$spray <- rownames(s)
head(s)
colnames(s)[1] <- "count"

library(plyr)
ddply(InsectSprays, .(spray), summarize, sum = sum(count))

spraySums <- ddply(InsectSprays, .(spray), summarize, sum = ave(count, FUN=(sum)))
spraySums


#############3
data(mtcars)
mtcars

narrow <- mtcars[, c("cyl", "gear", "vs", "mpg", "disp")]
narrow

library(reshape2)
wide1 <- tidied <- dcast(narrow, cyl + gear ~ vs, max)
wide1

wide2 <- tidied <- dcast(narrow, cyl + vs ~ gear, max)
wide2

notverywide <- aggregate(disp  ~  gear + vs + cyl, data = narrow, max)
notverywide


untidy <- with(narrow, tapply(mpg, list(cyl, vs, gear), max))
untidy
