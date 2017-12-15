# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' @export
start <- function() {
  cat("start: pkg:", environmentName(topenv(parent.frame())), "\n")
  print(topenv(parent.frame()))

  "!DEBUG starting..."

  api_file <- file.path(find.package("inspecter"), "api.R")
  "!DEBUG initialize plumber with route definitions from `api_file`"
  pr <- plumber::plumb(file = api_file)

  cat("init: pkg:", environmentName(topenv(parent.frame())), "\n")
  print(topenv(parent.frame()))

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
                     '| size:', format(object.size(x = res$body), standard = 'IEC', unit = 'auto'))`"
  })
  pr$registerHook("exit", function(){
    "!DEBUG shutting down at `log_timestamp()`"
  })

  "!DEBUG run plumber"
  pr$run(host = '0.0.0.0', port = 8091, debug = TRUE)
}
