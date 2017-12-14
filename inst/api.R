# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' @get /status
#' @json
status <- function() {
  message <- "All systems are online, captain."
  "!DEBUG service status request: `message`"
  return(list(status = message))
}

#' @param file
#' @param objects     # must be String or Array of Strings; if object non-existent, returns 500 Error
#' @get /api/v1/inspection/<id>
#' @json
rdataToJSON <- function(id, file = NA, objects = NA, res){
  # FIXME: do we need to clear other objects? in case yes, check out environments, see ?new.env
  
  # sanitize input
  id_sanitized <- gsub("\\W", "", id)
  file_sanitized <- gsub("\\W", "", file)
  
  error <- NA
  
  "!DEBUG get rdata file"
  if (!base::file.exists(id_sanitized)) {
    error <- "404 - requested compendium not found."
    error
  }
  
  if (is.na(file_sanitized)) {
    error <- "Error 400: No file specified."
    error
  }

  # FIXME Error handling for non-existent files does not work, throws:
  #       <simpleError in value[[3L]](cond): unused argument (cond)>
  
  # read file to workspace
  tryCatch({
      load(base::file.path(id_sanitized, file_sanitized))
    },
    warning = function() {
      error <- "Error 400: requested data file could not be found."
      error
    }
  )
  
  if (!is.na(error)) {
    return(error)
  }
  
  # FIXME for() loop does not work properly (tried with comma separated list of objects in query), throws:
  #       <simpleError in value[[3L]](cond): no loop for break/next, jumping to top level>
  
  if (!is.na(objects)) {
    for (o in objects) {
      tryCatch({
          mget(o)
        }, 
        error = function(e) {
          msg <- paste("Error: requested data does not exist. Object " , o , "could not be read.")
          status <- 400 # bad request
          error = c(status, msg, e)
          break
        })
    }
    if (!is.na(error)) { error }
    
    # only return object
    mget(objects)
  } else {
    # return full JSON
    mget(ls())
  }
}

