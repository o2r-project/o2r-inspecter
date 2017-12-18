FROM rocker/r-ver:3.4.3

RUN apt-get update -qq && apt-get install -y \
  git-core \
  libssl-dev \
  libcurl4-gnutls-dev \
  zlib1g-dev

# install dependencies before copying the package to reduce installation time of the package
RUN R -q -e 'install.packages(c("devtools", "plumber", "jsonlite", "debugme"))'

COPY . /inspecter
WORKDIR /inspecter
RUN R -q -e 'devtools::install(quick = TRUE)'

ENV DEBUGME=inspecter
ENV INSPECTER_BASEPATH=/inspecter/tests/testthat/data/

LABEL maintainer="o2r-project <https://o2r.info>"

ENTRYPOINT ["R"]
CMD ["-e", "inspecter::start()"]
