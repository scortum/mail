FROM ubuntu
MAINTAINER Marcus & Alex

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      exim4 \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ADD src/run-exim.sh /run-exim.sh
CMD "/run-exim.sh"

