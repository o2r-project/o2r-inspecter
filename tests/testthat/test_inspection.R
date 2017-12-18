# Copyright 2017 Opening Reproducible Research (http://o2r.info)

library("httr")
library("jsonlite")
context("/api/v1/inspection")

test_that("/api/v1/inspection/invalid_id complains about missing file query parameter (400, JSON)", {
  r <- GET("http://localhost:8091/api/v1/inspection/12345")
  expect_equal(status_code(r), 400)
  expect_true(jsonlite::validate(httr::content(r, as = "text", encoding = "UTF-8")))
})

test_that("/api/v1/inspection/invalid_id complains about missing file query parameter (400, JSON)", {
  r <- GET("http://localhost:8091/api/v1/inspection/12345")
  expect_equal(status_code(r), 400)
  expect_true(jsonlite::validate(httr::content(r, as = "text", encoding = "UTF-8")))
  data <- httr::content(r)
  expect_equal(names(data)[[1]], "error")
})

test_that("/api/v1/inspection/invalid_id?invalid_file complains about not existing compendium (400, JSON)", {
  r <- GET("http://localhost:8091/api/v1/inspection/12345?file=not.there")
  expect_equal(status_code(r), 400)
  expect_true(jsonlite::validate(httr::content(r, as = "text", encoding = "UTF-8")))
  data <- httr::content(r)
  expect_equal(names(data)[[1]], "error")
  expect_match(data$error, "compendium '12345' does not exist")
})
