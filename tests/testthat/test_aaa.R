# Copyright 2017 Opening Reproducible Research (http://o2r.info)

context("setup")

container_id <- NULL
build_result <- NULL

setup({
  # build, need to move context up two directory, then reset in finally
  build_result <<- tryCatch({
    setwd("../..")
    output <- system2(command = "docker",
                            args = "build --tag testspecter --file tests/testthat/Dockerfile .",
                            stdout = TRUE,
                            stderr = TRUE)
    output
  }, warning = function(w){
    output
  }, finally = {
    setwd("tests/testthat")
  })

  # run
  container_id <<- system2(command = "docker",
                           args = "container run --detach --publish 8091:8091 --name inspecter_test testspecter",
                           stdout = TRUE,
                           stderr = TRUE)
  Sys.sleep(2) # give container time to start
})

test_that("build completed", {
  expect_false(is.null(build_result))
  expect_equal(tail(build_result, n = 1), "Successfully tagged testspecter:latest")
})

test_that("container is started", {
  expect_false(is.null(container_id))
})
