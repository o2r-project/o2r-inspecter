anInteger <- 1
aDouble <- 2.3
aChar <- "a"
aString <- "The force is great in o2r."

numVector <- c(1,2,3.5,4.6,-7,.8)
charVector <- c("one", "two", "3")
logicalVector <- c(TRUE, TRUE, FALSE, FALSE, TRUE, FALSE)

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

orderedList <- list(name = "Fred", mynumbers = numVector, mymatrix = numericMatrix, age = 5.3)

factors <- c(rep("oneThing", 10), rep("otherThing", 20))
factors <- factor(factors)