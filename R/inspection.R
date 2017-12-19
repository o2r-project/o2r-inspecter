# Copyright 2017 Opening Reproducible Research (http://o2r.info)

#' GET /api/v1/inspection/<id> with JSON response
#'
#' @param compendium_id required path paramter - the identifier of the compendium
#' @param file required query parameter - the relative path to the file which should be opened
#' @param objects optional query parameter - names of objects in the binary file to include in the response
#' @param req plumber request object
#' @param res plumber response object
inspection <- function(compendium_id, file = NA, objects = NA, req, res){
  "!DEBUG for compendium '`compendium_id`' inspect objects '`toString(objects)`' (NA = all) from file '`file`'"

  # sanitize input
  id_sanitized <- base::gsub("\\W", "", compendium_id)
  if (base::is.na(id_sanitized) || base::nchar(id_sanitized) < 1) {
    msg <- "Path parameter '<id>' missing"
    res$status <- 400
    return(list(error = jsonlite::unbox(msg)))
  }
  file_sanitized <- base::gsub("[^a-zA-Z0-9./]+", "", file)
  if (base::is.na(file_sanitized) || base::nchar(file_sanitized) < 1) {
    msg <- "Query parameter 'file' missing"
    res$status <- 400
    return(list(error = jsonlite::unbox(msg)))
  }

  full_compendium_path <- base::file.path(base::getOption("inspecter.base.path"), id_sanitized)
  "!!DEBUG Get file `file_sanitized` for compendium `id_sanitized` from path `full_compendium_path`"

  if (!base::dir.exists(full_compendium_path)) {
    msg <- base::paste0("compendium '", id_sanitized, "' does not exist")
    res$status <- 400
    return(list(error = jsonlite::unbox(msg)))
  }

  full_file_path <- base::file.path(full_compendium_path, file_sanitized)
  if (!base::file.exists(full_file_path)) {
    msg <- base::paste0("file '", file_sanitized, "' does not exist in compendium ", id_sanitized)
    res$status <- 400
    return(base::list(error = jsonlite::unbox(msg)))
  }

  # read file to new environment
  compendium_env <- base::new.env()
  "!!DEBUG Loading file `full_file_path` to `capture.output(print(new.env()))`"
  base::load(full_file_path, envir = compendium_env)
  "!!DEBUG Loaded file, environment contents: `toString(ls(compendium_env, all.names = TRUE))`"

  .objects <- list()

  if (base::is.na(objects)) {
    # return all objects in the file
    .objects <- base::ls(envir = compendium_env, all.names = TRUE)
    response <- base::mget(.objects, envir = compendium_env)
    response <- .process_objects(response)
    "!!DEBUG Returning response: \n`capture.output(str(response, max.level = 2))`"
   base::rm("compendium_env")
   return(response)
  } else {
    .objects <- base::unlist(strsplit(x = objects, split = ","))
    .objects <- .objects[.objects != ""]
    "!!DEBUG Returning only `length(.objects)` object(s): `toString(.objects)`"

    unloadable <- base::list()
    .objects <- base::sapply(X = .objects, FUN = function(.o) {
      tryCatch({
          base::get(.o, envir = compendium_env)
          "!!!DEBUG '`.o`' is loadable: `base::get(.o, envir = compendium_env)`"
          return(.o)
      },
      error = function(e) {
        unloadable <<- base::c(unloadable,
                               paste0("Error: Object '", .o, "' does not exist in the file ", file_sanitized))
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
      response <- base::mget(.objects, envir = compendium_env)
      response <- .process_objects(response)

      if (base::length(unloadable) > 0)
        response <- base::c(response, list(errors = unlist(unloadable)))
    } else if (base::length(unloadable) > 0) {
      response <- base::list(errors = unlist(unloadable))
    } else {
      "!DEBUG Error state: `toString(unloadable)`"
      res$status <- 500
      return(base::list(error = jsonlite::unbox("Error loading objects")))
    }

    base::rm("compendium_env")
    return(response)
  }
}

.process_objects <- function(input) {
  out <- lapply(input, function(.o) {
    if (class(.o) == "call" || class(.o) == "expression")
      return(deparse(.o))
    else return(.o)
  })
  names(out) <- names(input)
  return(out)
}
