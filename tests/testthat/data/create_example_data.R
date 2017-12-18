# Copyright 2017 Opening Reproducible Research (http://o2r.info)

# manually set the wd to this file's wd!
# see https://www.statmethods.net/input/datatypes.html

# create directories in the data storage akin to compendium storage
sapply(X = c("kOSMO", "oZ5zA", "0Druu", "WQI9V"), FUN = dir.create)

# simple types
anInteger <- 1
aDouble <- 2.3
aChar <- "a"
aString <- "The force is great in o2r."
save(anInteger, aDouble, aChar, aString, file = "kOSMO/simple.RData")

# vectors
numericVector <- c(1,2,3.5,4.6,-7,.8)
characterVector <- c("one", "two", "3")
logicalVector <- c(TRUE, TRUE, FALSE, FALSE, TRUE, FALSE)
save(numericVector, characterVector, logicalVector, file = "0Druu/vectors.RData")

# matrix, data.frame, tables
numericMatrix <- matrix(1:20, nrow = 5, ncol = 4)
cells <- c(1,26,24,68)
rnames <- c("R1", "R2")
cnames <- c("C1", "C2")
namedMatrix <- matrix(cells, nrow = 2, ncol = 2, byrow = TRUE, dimnames = list(rnames, cnames))

x <- c(1,2,3,4)
y <- c(TRUE, TRUE, TRUE, FALSE)
z <- c("red", "white", "red", NA)
dataFrame <- data.frame(x,y,z)
names(dataFrame) <- c("ID", "Passed", "Colour")
save(namedMatrix, dataFrame, file = "oZ5zA/matrices.RData")

# lists
orderedList <- list(name = "Fred", mynumbers = numericVector, mymatrix = numericMatrix, age = 5.3)
emptyList <- vector("list", 5)
save(orderedList, emptyList, file = "0Druu/lists.RData")

# factors
factors <- factor(c(rep("oneThing", 10), rep("otherThing", 20)))
save(factors, file = "WQI9V/factors.RData")

# functions & environments
f <- function() "my fun function"
myFunction <- function(x, y) {
  x + y
}
myOtherFunction <- function(x, y) {
  paste0(x, y, collapse = "|")
}
myEnv <- new.env()
environment(f) <- myEnv
save(myFunction, myOtherFunction, file = "WQI9V/functions.RData")

# expressions & calls
xprssn <- expression(1 + 0:9)
cl <- call("round", 0.42)
save(xprssn, cl, file = "WQI9V/expressions.RData")
