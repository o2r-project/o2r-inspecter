# Copyright 2017 Opening Reproducible Research (http://o2r.info)

library("httr")
library("jsonlite")
context("/status")

test_that("status response is HTTP 200", {
  r <- GET("http://localhost:8091/status")
  expect_equal(status_code(r), 200)
})

test_that("status response contains valid JSON", {
  r <- GET("http://localhost:8091/status")
  expect_true(jsonlite::validate(httr::content(r, as = "text")))
})

test_that("response has only one property 'status'", {
  r <- GET("http://localhost:8091/status")
  data <- httr::content(r)
  expect_length(names(data), 1)
  expect_equal(names(data)[[1]], "status")
  expect_named(data, c("status"))
})
