# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' GET /api/v1/compendium with JSON response
list_compendia <- function() {
  dirs <- list.dirs(.inspecter_base_path, full.names = FALSE, recursive = FALSE)
  "!DEBUG returning list of `length(dirs)` compendia directories in data"
  return(dirs)
}
