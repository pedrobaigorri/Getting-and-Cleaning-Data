# Example of agreggation

attach(mtcars)
mtcars
mtcars$mpg <- as.character(mtcars$mpg)

mtcars$vs <- as.factor(mtcars$vs)

colnames(mtcars)
class(mtcars$disp)
aggdata <- aggregate(mtcars, by=list(cyl, vs), FUN=mean, na.rm=TRUE)


v2 <- rep(1, nrow(mtcars))
v2[1: (nrow(mtcars)/2)] <- rep (2, nrow(mtcars)/2)
v2[nrow(mtcars)] <- 3

v2
nrow(mtcars)

aggdata <- aggregate(. ~ cyl - vs, data = mtcars, mean)
aggdata <- aggregate(mtcars, list(cyl,vs), FUN= mean)
aggdata <- aggregate(mtcars, list(mpg = v2), FUN= mean)

aggdata

table(mtcars$cyl, mtcars$vs)
tail(mtcars)
