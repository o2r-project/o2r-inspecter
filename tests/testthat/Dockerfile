FROM rocker/verse:3.4.3

# install dependencies not in verse image here to reduce build time (caching) and installation time of the package
RUN R -q -e 'install.packages(c("plumber", "debugme"))'

COPY . /inspecter
WORKDIR /inspecter
RUN R -q -e 'devtools::install(quick = TRUE)'

ENV DEBUGME=inspecter
ENV INSPECTER_BASEPATH=/inspecter/tests/testthat/data/

LABEL maintainer="o2r-project <https://o2r.info>"

ENTRYPOINT ["R"]
CMD ["-e", "library('inspecter'); inspecter::start()"]
