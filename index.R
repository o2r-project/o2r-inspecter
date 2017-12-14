# Copyright 2017 Opening Reproducible Research (http://o2r.info)

if (require("debugme")) {
  # manually call debugme, because we're not in a package (yet)
  debugme::debugme()
}
library("plumber")
library("jsonlite")

"!DEBUG initialize plumber"
pr <- plumb("api.R")

# add logging hooks
pr$registerHook("preroute", function(req){
  message <- paste(as.character(Sys.time()), "|", req$REQUEST_METHOD, req$PATH_INFO, "|", 
                    req$HTTP_USER_AGENT, " from ", req$REMOTE_ADDR)
  cat(message)
  "!DEBUG this is a `message`"
})
pr$registerHook("postserialize", function(req){
  cat("Responded to", req$PATH_INFO, "...\n")
})
pr$registerHook("exit", function(){
  cat(as.character(Sys.time()), " | Shutting down inspecter. Bye bye!\n")
})


#' @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

"!DEBUG run plumber"
pr$run(port = 8091)

"!DEBUG o2r-inspecter started"
