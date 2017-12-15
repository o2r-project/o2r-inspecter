# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' @importFrom debugme debugme
.onLoad <- function(libname, pkgname) {
  cat("onLoad: libname:", libname, "environment:", environmentName(topenv(parent.frame())), "\n")
  print(topenv(parent.frame()))
  debugme::debugme()
}
