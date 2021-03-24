
FROM ubuntu:18.04@sha256:32776cc92b5810ce72e77aca1d949de1f348e1d281d3f00ebcc22a3adcdc9f42

COPY build-plugin.sh /

RUN apt-get clean && \
  apt-get update && \
  apt-get install -y  --no-install-recommends \
    ca-certificates \
    curl \
    sudo \
    && \
  /build-plugin.sh

RUN \
  tar cf vagrant.d.tgz --gzip -C ~ .vagrant.d


