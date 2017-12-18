# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' GET /status with JSON response
status <- function() {
  message <- "All systems are online, captain."
  "!DEBUG service status: `message`"
  return(list(status = message))
}
