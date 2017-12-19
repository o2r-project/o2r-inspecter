# o2r-inspecter

[![Build Status](https://travis-ci.org/o2r-project/o2r-inspecter.svg?branch=master)](https://travis-ci.org/o2r-project/o2r-inspecter) [![Microbadger](https://images.microbadger.com/badges/image/o2rproject/o2r-inspecter.svg)](https://microbadger.com/images/o2rproject/o2r-inspecter "badge by microbadger.com") [![](https://images.microbadger.com/badges/version/o2rproject/o2r-inspecter.svg)](https://microbadger.com/images/o2rproject/o2r-inspecter "badge by microbadger.com")

Inspection of binary files for the [o2r Web API](http://o2r.info/o2r-web-api/).

Implements the endpoint `/api/v1/inspection` using [plumber](https://www.rplumber.io/).

## Run

Configuration is done via environment variables.
They _must_ be set _before_ loading the package (i.e. `library("inspecter")`).

From R:

```r
Sys.setenv(DEBUGME = "inspecter")
library("inspecter")
inspecter::start()
```

With Docker:

```bash
docker build --tag inspecter .
docker run --rm -it -p 8091:8091 inspecter
```

## Configuration

- `INSPECTER_PORT`
  The port to run the service at, defaults to `8091`
- `INSPECTER_HOST`
  The host to listen to, defaults to `0.0.0.0`
- `INSPECTER_BASEPATH`
  The data directory, defaults to `/tmp/o2r/compendium` (i.e. inspecter only reads files from compendia, not from jobs)

### API docs

See [http://o2r.info/o2r-web-api/compendium/files/#file-inspection-rdata](http://o2r.info/o2r-web-api/compendium/files/#file-inspection-rdata)

`<ip>:8091/status` shows the microservice status.

For security reasons, inputs (namely `file` and `objects`) are processed to contain only characters allowed for filenames or R objects respectively.

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

`plumber` integrates a swagger UI, you can open it at http://127.0.0.1:8091/__swagger__/.

### Run tests

```r
devtools::test()
```

We must start the service independently of the tests, so the tests include building the inspecter Docker image and starting/removing of a Docker container.
**It's recommended to build the image manually once to create a build cache**.

The test relies on it's own Dockerfile at `tests/testthat/Dockerfile`, which reduces rebuild time to improve local development experience.

When the test fails with "too many failures", the Docker container `inspecter_test` must be removed manually before re-running the tests.

## License

o2r muncher is licensed under Apache License, Version 2.0, see file LICENSE.

Copyright (C) 2017 - o2r project.
