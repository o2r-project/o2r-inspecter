# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' @export
start <- function() {
  print(Sys.getenv())

  source(file.path(find.package("inspecter"), "plumber.R"))
}
