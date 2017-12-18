# Copyright 2017 Opening Reproducible Research (http://o2r.info)

library("httr")
library("jsonlite")
context("/api/v1/inspection - simple data types")

test_that("/api/v1/inspection/kOSMO?file=simple.RData gives HTTP 200 with valid JSON)", {
  r <- GET("http://localhost:8091/api/v1/inspection/kOSMO?file=simple.RData")
  expect_equal(status_code(r), 200)
  expect_true(jsonlite::validate(httr::content(r, as = "text", encoding = "UTF-8")))
})

test_that("/api/v1/inspection/kOSMO?file=simple.RData gives all objects)", {
  r <- GET("http://localhost:8091/api/v1/inspection/kOSMO?file=simple.RData")
  data <- httr::content(r)
  expect_length(names(data), 4)
  expect_equal(names(data), c("aChar", "aDouble", "anInteger", "aString"))
})

test_that("/api/v1/inspection/kOSMO?file=simple.RData gives correct object content", {
  r <- GET("http://localhost:8091/api/v1/inspection/kOSMO?file=simple.RData")
  data <- httr::content(r)
  expect_equal(data$aChar, list("a"))
  expect_equal(data$aDouble, list(2.3))
  expect_equal(data$anInteger, list(1))
  expect_match(data$aString[[1]], "force is great")
})

test_that("/api/v1/inspection/... returns only selected elements (in requested order)", {
  r <- GET("http://localhost:8091/api/v1/inspection/kOSMO?file=simple.RData&objects=aDouble,aChar")
  data <- httr::content(r)
  expect_length(names(data), 2)
  expect_equal(names(data), c("aDouble", "aChar"))
  raw_data <- httr::content(r, as = "text", encoding = "UTF-8")
  expect_false(grepl(pattern = "anInteger", x = raw_data))
  expect_false(grepl(pattern = "aString", x = raw_data))
})

test_that("/api/v1/inspection/... can handle empty object names", {
  r <- GET("http://localhost:8091/api/v1/inspection/kOSMO?file=simple.RData&objects=,,aDouble,,aChar,,,,")
  data <- httr::content(r)
  expect_length(names(data), 2)
  expect_equal(names(data), c("aDouble", "aChar"))
})

test_that("/api/v1/inspection/... can handle mixed existing and non-existing object names", {
  r <- GET("http://localhost:8091/api/v1/inspection/kOSMO?file=simple.RData&objects=bar,anInteger,foo")
  data <- httr::content(r)
  expect_length(names(data), 2)
  expect_equal(data$anInteger, list(1))
  expect_equal(names(data), c("anInteger", "errors"))
})

test_that("/api/v1/inspection/... can handle only non-existing object names, one error per missing object", {
  r <- GET("http://localhost:8091/api/v1/inspection/kOSMO?file=simple.RData&objects=foo,bar")
  data <- httr::content(r)
  expect_equal(names(data), c("errors"))
  expect_length(data$errors, 2)
  expect_match(data$errors[[1]], "'foo'")
  expect_match(data$errors[[2]], "'bar'")
})
