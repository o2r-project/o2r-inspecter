# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' GET /api/v1/inspection/<id> with JSON response
#'
#' required parameters:
#' - id
#'
#' required query strings:
#' - file
#'
#' optional query strings:
#' - objects
#'
#' @param req
#' @param res
inspection <- function(compendium_id, file = NA, objects = NA, req, res){
  "!DEBUG for compendium '`compendium_id`' inspect objects '`toString(objects)`' (NA = all) from file '`file`'"

  # sanitize input
  id_sanitized <- gsub("\\W", "", compendium_id)
  if (is.na(id_sanitized) || nchar(id_sanitized) < 1) {
    msg <- "Path parameter '<id>' missing"
    res$status <- 400
    return(list(error = jsonlite::unbox(msg)))
  }
  file_sanitized <- gsub("[^a-zA-Z0-9.]+", "", file)
  if (is.na(file_sanitized) || nchar(file_sanitized) < 1) {
    msg <- "Query parameter 'file' missing"
    res$status <- 400
    return(list(error = jsonlite::unbox(msg)))
  }

  full_compendium_path <- file.path(.inspecter_base_path, id_sanitized)
  "!!DEBUG Get file `file_sanitized` for compendium `id_sanitized` from path `full_compendium_path`"

  if (!base::dir.exists(full_compendium_path)) {
    msg <- paste0("compendium '", id_sanitized, "' does not exist")
    res$status <- 400
    return(list(error = jsonlite::unbox(msg)))
  }

  full_file_path <- base::file.path(full_compendium_path, file_sanitized)
  if (!base::file.exists(full_file_path)) {
    msg <- paste0("file '", file_sanitized, "' does not exist in compendium ", id_sanitized)
    res$status <- 400
    return(list(error = jsonlite::unbox(msg)))
  }

  # read file to new environment
  compendium_env <- new.env()
  "!!DEBUG Loading file `full_file_path` to `capture.output(print(new.env()))`"
  load(full_file_path, envir = compendium_env)
  "!!DEBUG Loaded file, environment contents: `toString(ls(compendium_env, all.names = TRUE))`"

  if (is.na(objects)) {
    # return all objects in the file
    response <- mget(ls(envir = compendium_env, all.names = TRUE), envir = compendium_env)
    "!!DEBUG Returning response: \n`capture.output(str(response, max.level = 2))`"
   rm("compendium_env")
   return(response)
  } else {
    .objects <- base::unlist(strsplit(x = objects, split = ","))
    .objects <- .objects[.objects != ""]
    "!!DEBUG Returning only `length(.objects)` object(s): `toString(.objects)`"

    unloadable <- list()
    .objects <- base::sapply(X = .objects, FUN = function(.o) {
      tryCatch({
          .loaded <- get(.o, envir = compendium_env)
          "!!!DEBUG Can load '`.o`': `toString(.loaded)`"
          return(.o)
      },
      error = function(e) {
        "!DEBUG Error loading object `.o`: `toString(e)`"
        unloadable <<- c(unloadable, paste0("Error: Object '", .o, "' does not exist in the file ", file_sanitized))
        return(NULL)
      })
    })
    .objects <- base::unlist(.objects[!sapply(.objects, is.null)])
    unloadable <- base::unlist(unloadable)
    "!DEBUG Loadable objects: `toString(.objects)`"
    "!DEBUG Unloadable: `toString(unloadable)`"

    # only return selected objects from the file
    response <- NULL
    if (length(.objects) > 0) {
      response <- mget(.objects, envir = compendium_env)

      if (length(unloadable) > 0)
        response <- c(response, list(errors = unlist(unloadable)))
    } else if (length(unloadable) > 0) {
      response <- list(errors = unlist(unloadable))
    } else {
      "!DEBUG Error state: `toString(unloadable)`"
      res$status <- 500
      return(list(error = jsonlite::unbox("Error loading objects")))
    }

    rm("compendium_env")
    return(response)
  }
}
