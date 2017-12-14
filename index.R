setwd("~/Documents/o2r/o2r-inspecter/")

Sys.setenv(DEBUGME = "api")

library(debugme)
"!DEBUG include plumber"
library(plumber)

"!DEBUG initialize plumber"
r <- plumb("~/Documents/o2r/o2r-inspecter/api.R")

"!DEBUG run plumber"
r$run(port=8091)