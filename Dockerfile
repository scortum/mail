FROM ubuntu
MAINTAINER Marcus & Alex

ENV DEBIAN_FRONTEND noninteractive

# https://docs.cyrus.foundation/imap/installation/distributions/ubuntu.html
RUN apt-get update && \
    apt-get -y install exim4 \
                       cyrus-admin  \
                       cyrus-clients  \
			       cyrus-doc  \
                       cyrus-imapd  \
                       sasl2-bin
# TODO: Wenn alles läuft, das cleanup wieder einschalten.
#
#  && \
#  apt-get clean && \
#  rm -rf /var/lib/apt/lists/*


## create some default use, cyrus is configured as admin in imapd.conf
#RUN echo "cyrus"|saslpasswd2 -u test -c cyrus -p
#RUN echo "bob"|saslpasswd2 -u test -c bob -p
#RUN echo "alice"|saslpasswd2 -u test -c alice -p
#
# CMD /usr/sbin/cyrmaster

ADD src/run-exim.sh /run-exim.sh
CMD "/run-exim.sh"

