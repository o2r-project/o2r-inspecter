# Copyright 2017 Opening Reproducible Research (http://o2r.info)

library("plumber")
library("jsonlite")
library("kimisc")
library("debugme")

#cat("debug:", Sys.getenv("DEBUGME"), "\n")
#debugme::debugme()

"!DEBUG initialize plumber"
pr <- plumb(file = file.path(dirname(kimisc::thisfile()), "api.R"))

# add logging hooks
log_timestamp <- function() {
  return(paste(as.character(Sys.time()), "|"))
}
pr$registerHook("preroute", function(req){
  message <- paste(log_timestamp(), req$REQUEST_METHOD, req$PATH_INFO, "|",
                    req$HTTP_USER_AGENT, " from ", req$REMOTE_ADDR)
  cat(message, "\n")
  "!DEBUG this is a `message`"
})
pr$registerHook("postserialize", function(req, res){
  message <- paste(log_timestamp(), req$REQUEST_METHOD, req$PATH_INFO, "| response sent:", res$status,
                  "| size:", format(object.size(x = res$body), standard = "IEC", unit = "auto"))
  cat(message, "\n")
  "!DEBUG this is a `message`"
})
pr$registerHook("exit", function(){
  cat(log_timestamp(), "Shutting down inspecter. Bye bye!\n")
})


#' @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

"!DEBUG run plumber"
pr$run(host = '0.0.0.0', port = 8091)

"!DEBUG o2r-inspecter started"
