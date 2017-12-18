# Copyright 2017 Opening Reproducible Research (http://o2r.info)

# configure global variables
.inspecter_base_path <- Sys.getenv("INSPECTER_BASEPATH", unset = "/tmp/o2r")
.inspecter_port <- Sys.getenv("INSPECTER_PORT", unset = "8091")
.inspecter_host <- Sys.getenv("INSPECTER_HOST", unset = "0.0.0.0")


.log_timestamp <- function() {
  return(paste(as.character(Sys.time()), "|"))
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
  "!DEBUG starting..."

  pr <- plumber::plumber$new()

  # add logging hooks
  pr$registerHook("preroute", function(req){
    "!DEBUG `paste(.log_timestamp(), req$REQUEST_METHOD, req$PATH_INFO, ' ', req$QUERY_STRING, '|',
                    req$HTTP_USER_AGENT, 'from', req$REMOTE_ADDR)`"
  })
  pr$registerHook("postserialize", function(req, res){
    "!DEBUG `paste(.log_timestamp(), req$REQUEST_METHOD, req$PATH_INFO, ' ', req$QUERY_STRING, '|',
                    'Response sent:', res$status,
                    '| size:', format(utils::object.size(x = res$body), standard = 'IEC', unit = 'auto'))`"
  })
  pr$registerHook("exit", function(){
    "!DEBUG shutting down at `.log_timestamp()`"
  })

  # add handlers for endpoints, annotations don't play nicely with debugme and environments,
  # see
  pr$handle(method = "GET", path = "/status",
            handler = inspecter:::status,
            serializer = plumber::serializer_json())
  pr$handle(method = "GET", path = "/api/v1/compendium",
            handler = inspecter:::list_compendia,
            serializer = plumber::serializer_json())
  pr$handle(method = "GET", path = "/api/v1/inspection/<compendium_id>",
            handler = inspecter:::inspection,
            serializer = plumber::serializer_json())

  print(pr)
  "!DEBUG plumber$run()"
  pr$run(host = .inspecter_host, port = as.numeric(.inspecter_port), debug = TRUE)
}
