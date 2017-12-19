# Copyright 2017 Opening Reproducible Research (http://o2r.info)

.log_timestamp <- function() {
  return(paste(as.character(Sys.time()), "|"))
}

# directo copy of plumber::serialzer_json, see https://github.com/trestletech/plumber/issues/220
.serializer_json <- function(...){
  # nolint start
  function(val, req, res, errorHandler){
    tryCatch({
      json <- jsonlite::toJSON(val, ...)

      res$setHeader("Content-Type", "application/json")
      res$body <- json

      return(res$toResponse())
    }
    , error = function(e){
      errorHandler(req, res, e)
    })
  }
  # nolint end
}

#' Start the inspecter microservice
#'
#' All configuration via environment variables.
#'
#' @return function does not return but starts listening on the defined port and HTTP endpoints
#'
#' @export
#' @importFrom utils object.size
start <- function() {
  "!DEBUG Starting..."
  "!DEBUG Configuration:
    base path:  `getOption('inspecter.base.path')`
    host:       `getOption('inspecter.host')`
    port:       `getOption('inspecter.port')`"
  "!!!DEBUG Full environment:
  `capture.output(base::Sys.getenv())`"

  pr <- plumber::plumber$new()

  # add logging hooks
  pr$registerHook("preroute", function(req){ # nolint
    "!DEBUG `paste(.log_timestamp(), req$REQUEST_METHOD, req$PATH_INFO, ' ', req$QUERY_STRING, '|',
                    req$HTTP_USER_AGENT, 'from', req$REMOTE_ADDR)`"
  })
  pr$registerHook("postserialize", function(req, res){ # nolint
    "!DEBUG `paste(.log_timestamp(), req$REQUEST_METHOD, req$PATH_INFO, ' ', req$QUERY_STRING, '|',
                    'Response sent:', res$status,
                    '| size:', format(utils::object.size(x = res$body), standard = 'IEC', unit = 'auto'))`"
  })
  pr$registerHook("exit", function(){ # nolint
    "!DEBUG shutting down at `.log_timestamp()`"
  })

  # add handlers for endpoints, annotations don't play nicely with debugme and environments
  pr$handle(method = "GET", path = "/status", # nolint
            handler = inspecter:::status,
            serializer = plumber::serializer_json())
  pr$handle(method = "GET", path = "/api/v1/compendium", # nolint
            handler = inspecter:::list_compendia,
            serializer = plumber::serializer_json())
  pr$handle(method = "GET", path = "/api/v1/inspection/<compendium_id>", # nolint
            handler = inspecter:::inspection,
            serializer = .serializer_json(force = TRUE)) # plumber::serializer_json())

  print(pr)
  "!DEBUG plumber$run()"
  pr$run(host = base::getOption("inspecter.host"),
         port = as.numeric(base::getOption("inspecter.port")),
         debug = TRUE)
}
