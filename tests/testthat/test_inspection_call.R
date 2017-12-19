# Copyright 2017 Opening Reproducible Research (http://o2r.info)

library("httr")
library("jsonlite")
context("/api/v1/inspection - calls and expressions")

test_that("/api/v1/inspection/WQI9V?file=expressions.RData gives string representation of call", {
  r <- GET("http://localhost:8091/api/v1/inspection/WQI9V?file=expressions.RData")
  data <- httr::content(r)
  expect_equal(names(data)[[1]], "cl")
  expect_equal(unlist(data$cl), "round(0.42)")
})

test_that("/api/v1/inspection/WQI9V?file=expressions.RData gives string representation of expression", {
  r <- GET("http://localhost:8091/api/v1/inspection/WQI9V?file=expressions.RData")
  data <- httr::content(r)
  expect_equal(names(data)[[2]], "xprssn")
  expect_equal(unlist(data$xprssn), "expression(1 + 0:9)")
})
