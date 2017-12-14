# o2r-inspecter

Inspection of binary files for the [o2r Web API](http://o2r.info/o2r-web-api/).

Implements the endpoint `/api/v1/inspection` using [plumber]().

## Run

From R:

```r
Sys.setenv(DEBUGME = "api", DEBUGME_OUTPUT_FILE="log.txt")
source("index.R")
```

From a shell:

```bash
```

With Docker:

```bash
docker run --rm -p 8091:8000 -v $(pwd):/inspecter trestletech/plumber /inspecter/index.R
```

`/api/v1/inspestion/<compendium_id>?file=filename.RData`
returns contents of an `.RData`-file. Currently only possible within the `o2r-inspecter/test/` directory with mock compendium directory `testCompendium`.
Name of file must be correct, error handling breaks. 

`@param objects`
if not specified, entire content of `.RData`-file is returned. Currently, only one object can be specified; specifying more than one breaks the `for()`-loop.

## Configuration

- `INSPECTER_PORT`
  The port to run the service at, defaults to `8091`

## Development

`plumber` integrates a swagger UI, you can normally open it at http://127.0.0.1:8091/__swagger__/.

`<ip>:8091/api` shows the microservice status.

## License

o2r muncher is licensed under Apache License, Version 2.0, see file LICENSE.

Copyright (C) 2017 - o2r project.
