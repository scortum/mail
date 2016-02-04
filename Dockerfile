FROM ubuntu
MAINTAINER Marcus & Alex

ENV DEBIAN_FRONTEND noninteractive

# https://docs.cyrus.foundation/imap/installation/distributions/ubuntu.html
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y exim4 \
                       cyrus-admin cyrus-clients cyrus-doc cyrus-imapd sasl2-bin \
                       supervisor

RUN mkdir -p /var/log/supervisor

# TODO: Enable cleanup once everything works :-)
#  && \
#  apt-get clean && \
#  rm -rf /var/lib/apt/lists/*


# TODO: Delete this once it works :-)
RUN  apt-get install -y vim emacs

# Cyrus Installation:
RUN  mv  /etc/cyrus.conf  /etc/cyrus.conf.orig &&  \
     mv  /etc/imapd.conf  /etc/imapd.conf.orig 
COPY src/cyrus/cyrus.conf /etc/cyrus.conf
COPY src/cyrus/imapd.conf  /etc/imapd.conf
## create some default use, cyrus is configured as admin in imapd.conf
#RUN echo "cyrus"|saslpasswd2 -u test -c cyrus -p
#RUN echo "bob"|saslpasswd2 -u test -c bob -p
#RUN echo "alice"|saslpasswd2 -u test -c alice -p
#
# CMD /usr/sbin/cyrmaster

COPY src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 25 143 993
COPY   src/run.sh /run.sh
CMD    "/run.sh"

