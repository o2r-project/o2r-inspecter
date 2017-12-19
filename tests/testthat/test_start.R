# Copyright 2017 Opening Reproducible Research (http://o2r.info)

library("httr")
library("jsonlite")
context("/api, api/v1, etc.")

test_that("/api is HTTP 404 with valid JSON", {
  r <- GET("http://localhost:8091/api")
  expect_equal(status_code(r), 404)
  expect_true(jsonlite::validate(httr::content(r, as = "text", encoding = "UTF-8")))
})

test_that("/api/v1 is HTTP 404 with valid JSON", {
  r <- GET("http://localhost:8091/api/v1")
  expect_equal(status_code(r), 404)
  expect_true(jsonlite::validate(httr::content(r, as = "text", encoding = "UTF-8")))
})

test_that("/api/v1/inspection is HTTP 404 with valid JSON", {
  r <- GET("http://localhost:8091/api/v1/inspection")
  expect_equal(status_code(r), 404)
  expect_true(jsonlite::validate(httr::content(r, as = "text", encoding = "UTF-8")))
})
