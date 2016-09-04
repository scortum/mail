FROM ubuntu
MAINTAINER Marcus & Alex

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    exim4 exim4-daemon-heavy \
    cyrus-admin cyrus-clients cyrus-doc cyrus-imapd \
    sasl2-bin \
    supervisor \
    ca-certificates \
    wget \
    emacs vim \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

RUN mkdir -p /var/log/supervisor

# Install Forego
ADD https://github.com/jwilder/forego/releases/download/v0.16.1/forego /usr/local/bin/forego
RUN chmod u+x /usr/local/bin/forego


# Cyrus Installation:
RUN  mv  /etc/cyrus.conf  /etc/cyrus.conf.orig &&  \
     mv  /etc/imapd.conf  /etc/imapd.conf.orig 
COPY src/cyrus/cyrus.conf /etc/cyrus.conf
COPY src/cyrus/imapd.conf  /etc/imapd.conf

COPY src/exim/exim_sasl2.conf /usr/lib/sasl2/exim.conf
RUN mkdir /var/run/cyrus
RUN chown cyrus /var/run/cyrus
RUN chmod a+x /var/run/saslauthd

## create some default use, cyrus is configured as admin in imapd.conf
#RUN echo "cyrus"|saslpasswd2 -u test -c cyrus -p
#RUN echo "bob"|saslpasswd2 -u test -c bob -p
#RUN echo "alice"|saslpasswd2 -u test -c alice -p
#
# CMD /usr/sbin/cyrmaster

COPY src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY src/Procfile         /Procfile

EXPOSE 25 143 993
COPY   src/run.sh /run.sh
CMD    "/run.sh"

