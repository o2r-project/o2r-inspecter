# Copyright 2017 Opening Reproducible Research (http://o2r.info)

library("httr")
library("jsonlite")
context("/api/v1/inspection - files from subdirs and filenames with all allowed characters")

test_that("/api/v1/inspection/WQI9V?file=subdir/functions.RData gives HTTP 200 with valid JSON)", {
  r <- GET("http://localhost:8091/api/v1/inspection/WQI9V?file=subdir/functions.RData")
  expect_equal(status_code(r), 200)
  expect_true(jsonlite::validate(httr::content(r, as = "text", encoding = "UTF-8")))
})

test_that("/api/v1/inspection/WQI9V?file=subdir/functions.RData gives all objects)", {
  r <- GET("http://localhost:8091/api/v1/inspection/WQI9V?file=subdir/functions.RData")
  data <- httr::content(r)
  expect_length(names(data), 2)
  expect_equal(names(data), c("myFunction", "myOtherFunction"))
})

test_that("/api/v1/inspection/WQI9V?file=subdir/classes_and.also-methods.RData gives HTTP 200 with valid JSON)", {
  r <- GET("http://localhost:8091/api/v1/inspection/WQI9V?file=subdir/classes_and.also-methods.RData")
  expect_equal(status_code(r), 200)
  expect_true(jsonlite::validate(httr::content(r, as = "text", encoding = "UTF-8")))
})

test_that("/api/v1/inspection/WQI9V?file=subdir/functions.RData gives all objects)", {
  r <- GET("http://localhost:8091/api/v1/inspection/WQI9V?file=subdir/classes_and.also-methods.RData")
  data <- httr::content(r)
  expect_length(names(data), 4)
  expect_equal(names(data), c("a", "alice", "class3", "john"))
})
