# Copyright 2017 Opening Reproducible Research (http://o2r.info)

library("httr")
library("jsonlite")
context("/api/v1/inspection - matrix and data.frame")

test_that("/api/v1/inspection/oZ5zA?file=matrices.RData gives HTTP 200 with valid JSON)", {
  r <- GET("http://localhost:8091/api/v1/inspection/kOSMO?file=simple.RData")
  expect_equal(status_code(r), 200)
  expect_true(jsonlite::validate(httr::content(r, as = "text", encoding = "UTF-8")))
})

test_that("/api/v1/inspection/oZ5zA?file=matrices.RData gives all objects)", {
  r <- GET("http://localhost:8091/api/v1/inspection/oZ5zA?file=matrices.RData")
  data <- httr::content(r)
  expect_length(names(data), 2)
  expect_equal(names(data), c("dataFrame", "namedMatrix"))
})

test_that("/api/v1/inspectionoZ5zA?file=matrices.RData gives correct object content", {
  r <- GET("http://localhost:8091/api/v1/inspection/oZ5zA?file=matrices.RData")
  data <- httr::content(r)
  expect_equal(data[["dataFrame"]][[3]], list("ID" = 3,
                                              "Passed" = TRUE,
                                              "Colour" = "red"))
  expect_equal(data[["namedMatrix"]][[1]], list(1, 26))
})
