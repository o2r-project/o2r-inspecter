#' @get /api/v1/inspection/test
test <- function() {
  reply <- "All systems are online, captain."
  reply
}

#' @param file
#' @param object
#' @get /api/v1/inspection/<compendium_id>
rdataToJSON <- function(compendium_id, file, object) {
  
  # set cwd to config.compendia.compendium_id !?
  
  if (missing(file)) {
    break("Please specify a file.")
  }
  
  # read file and build JSON
  
  if (!missing(object)) {
    # only return object
  } else {
    # return full JSON
  }
}