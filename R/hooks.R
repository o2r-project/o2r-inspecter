# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' @importFrom debugme debugme
.onLoad <- function(libname, pkgname) {
  debugme::debugme()

  #if (as.logical(Sys.getenv("INSPECTER_AUTOSTART", unset = "FALSE"))
  #    && !is.null(getOption("R_DEFAULT_PACKAGES"))) {
  #  warning("INSPECTER_AUTOSTART is activated, use only for development.")
  #  inspecter:::start()
  #}
}
