FROM ubuntu
MAINTAINER Marcus & Alex

# ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      exim4 \
      cyrus-admin cyrus-clients cyrus-imapd sasl2-bin

#  && \
#  apt-get clean && \
#  rm -rf /var/lib/apt/lists/*

ADD src/run-exim.sh /run-exim.sh
CMD "/run-exim.sh"

