# o2r-inspecter

Inspection of binary files for the [o2r Web API](http://o2r.info/o2r-web-api/).

Implements the endpoint `/api/v1/inspection` using [plumber](https://www.rplumber.io/).

## Run

From R:

```r
Sys.setenv(DEBUGME = "inspecter")
library("inspecter")
inspecter::start()
```

With Docker:

```bash
docker build --tag inspecter .
docker run --rm -it -p 8091:8081 inspecter
```

`/api/v1/inspection/<compendium_id>?file=filename.RData`
returns contents of an `.RData`-file. Currently only possible within the `o2r-inspecter/test/` directory with mock compendium directory `testCompendium`.
Name of file must be correct, error handling breaks. 

`@param objects`
if not specified, entire content of `.RData`-file is returned. Currently, only one object can be specified; specifying more than one breaks the `for()`-loop.

`<ip>:8091/api` shows the microservice status.

## Configuration

- `INSPECTER_PORT`
  The port to run the service at, defaults to `8091`
- `INSPECTER_HOST`
  The host to listen to, defaults to `0.0.0.0`
- `INSPECTER_BASEPATH`
  The data directory, defaults to `/tmp/o2r`

### API docs

`plumber` integrates a swagger UI, you can normally open it at http://127.0.0.1:8091/__swagger__/.

## Development

```r
Sys.setenv("DEBUGME" = "inspecter", "INSPECTER_BASEPATH" = file.path(getwd(), "tests/testthat/data"))
library("inspecter")
inspecter::start()
```

For developing tests, it is useful to run the service from the terminal and have the R session for writing the tests:

```bash
DEBUGME=inspecter INSPECTER_BASEPATH=$(pwd)/tests/testthat/data R -q -e 'library("inspecter"); inspecter::start()'
```

### Run tests

```r
devtools::test()
```

We must start the service independently of the tests, so the tests include building the inspecter Docker image and starting/removing of a Docker container.
**It's recommended to build the image manually once to create a build cache**.

The test relies on it's own Dockerfile at `tests/testthat/Dockerfile`, which tries to reduce rebuild time to improve local development experience.

## License

o2r muncher is licensed under Apache License, Version 2.0, see file LICENSE.

Copyright (C) 2017 - o2r project.
