# Copyright 2017 Opening Reproducible Research (http://o2r.info)

context("teardown")

teardown({
  system2(command = "docker",
          args = "container rm --force inspecter_test",
          stdout = TRUE,
          stderr = TRUE)
})
