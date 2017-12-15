# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' Start the inspecter microservice
#'
#' All configuration via environment variables.
#'
#' @return a Plumber router
#'
#' @export
#' @importFrom utils object.size
start <- function(api = "api.R") {
  "!DEBUG starting..."

  api_file <- file.path(find.package("inspecter"), api)
  "!DEBUG initialize plumber with route definitions from `api_file`"
  pr <- plumber::plumb(file = api_file)

  # add logging hooks
  log_timestamp <- function() {
    return(paste(as.character(Sys.time()), "|"))
  }
  pr$registerHook("preroute", function(req){
    "!DEBUG `paste(log_timestamp(), req$REQUEST_METHOD, req$PATH_INFO, '|',
                     req$HTTP_USER_AGENT, 'from', req$REMOTE_ADDR)`"
  })
  pr$registerHook("postserialize", function(req, res){
    "!DEBUG `paste(log_timestamp(), req$REQUEST_METHOD, req$PATH_INFO, '| Response sent:', res$status,
                     '| size:', format(utils::object.size(x = res$body), standard = 'IEC', unit = 'auto'))`"
  })
  pr$registerHook("exit", function(){
    "!DEBUG shutting down at `log_timestamp()`"
  })

  "!DEBUG run plumber"
  pr$run(host = '0.0.0.0', port = 8091, debug = TRUE)
}
