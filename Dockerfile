FROM rocker/r-ver:3.4.3

RUN apt-get update -qq && apt-get install -y \
  git-core \
  libssl-dev \
  libcurl4-gnutls-dev \
  zlib1g-dev

RUN R -e 'install.packages(c("devtools"))'

COPY . /inspecter
WORKDIR /inspecter
RUN R -e 'devtools::install()'
RUN rm -r /inspecter

LABEL maintainer="o2r-project <https://o2r.info>" \
  org.label-schema.vendor="o2r project" \
  org.label-schema.url="http://o2r.info" \
  org.label-schema.name="inspecter" \
  org.label-schema.description="Inspect binary files from compendia" \
  org.label-schema.version=$VERSION \
  org.label-schema.vcs-url=$VCS_URL \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.docker.schema-version="rc1"

ENTRYPOINT ["R"]
CMD ["-e", "inspecter::start()"]
