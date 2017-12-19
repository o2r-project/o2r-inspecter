# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' @importFrom debugme debugme
.onLoad <- function(libname, pkgname) {
  debugme::debugme()
}

.onAttach <- function(libname, pkgname) {
  # load configuration from environment variables
  .inspecter_options <- base::list(
    inspecter.base.path = base::Sys.getenv("INSPECTER_BASEPATH", unset = "/tmp/o2r"), # nolint
    inspecter.port = base::Sys.getenv("INSPECTER_PORT", unset = "8091"),
    inspecter.host = base::Sys.getenv("INSPECTER_HOST", unset = "0.0.0.0")
  )

  op <- options()
  toset <- !(base::names(.inspecter_options) %in% base::names(op))
  if (base::any(toset)) base::options(.inspecter_options[toset])

  "!!DEBUG Loaded configuration: `toString(paste(names(.inspecter_options), '=', .inspecter_options, sep = ''))`"
}
