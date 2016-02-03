FROM ubuntu
MAINTAINER Marcus & Alex

ENV DEBIAN_FRONTEND noninteractive

# https://docs.cyrus.foundation/imap/installation/distributions/ubuntu.html
RUN apt-get update && \
    apt-get install -y exim4 \
                       cyrus-admin  \
                       cyrus-clients  \
			       cyrus-doc  \
                       cyrus-imapd  \
                       sasl2-bin

# TODO: Enable cleanup once everything works :-)
#  && \
#  apt-get clean && \
#  rm -rf /var/lib/apt/lists/*


## create some default use, cyrus is configured as admin in imapd.conf
#RUN echo "cyrus"|saslpasswd2 -u test -c cyrus -p
#RUN echo "bob"|saslpasswd2 -u test -c bob -p
#RUN echo "alice"|saslpasswd2 -u test -c alice -p
#
# CMD /usr/sbin/cyrmaster

# TODO: Delete this once it works :-)
RUN apt-get install -y vim emacs

ADD src/run-exim.sh /run-exim.sh
CMD "/run-exim.sh"

