# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' GET /api/v1/compendium with JSON response
list_compendia <- function() {
  dirs <- base::list.dirs(getOption("inspecter.base.path"), full.names = FALSE, recursive = FALSE)
  "!DEBUG returning list of `length(dirs)` compendia directories from `getOption('inspecter.base.path')`"
  return(dirs)
}
