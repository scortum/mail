FROM apky/ubik AS apky-ubik
 
FROM ubuntu:20.04
LABEL maintainers="Marcus & Alex"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

RUN apt-get update \
 && apt-get -y upgrade \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    exim4 exim4-daemon-heavy \
    cyrus-admin cyrus-clients cyrus-doc cyrus-imapd \
    sasl2-bin \
    ca-certificates \
    wget \
    emacs vim \
    strace \
    rsyslog \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

# setup rsyslogd
RUN sed 's/$ModLoad imklog/#$ModLoad imklog/' -i /etc/rsyslog.conf  \
 && sed 's/$KLogPermitNonKernelFacility on/#$KLogPermitNonKernelFacility on/' -i /etc/rsyslog.conf  \
 && sed 's/$FileOwner syslog/$FileOwner root/' -i /etc/rsyslog.conf  \
 && sed 's/$PrivDropToUser syslog/#$PrivDropToUser syslog/' -i /etc/rsyslog.conf  \
 && sed 's/$PrivDropToGroup syslog/#$PrivDropToGroup syslog/' -i /etc/rsyslog.conf  \
 && mv /etc/rsyslog.d/50-default.conf /etc/rsyslog.d/50-default.conf.orig \
 && head -n-5 /etc/rsyslog.d/50-default.conf.orig > /etc/rsyslog.d/50-default.conf


# Exim Installation:
RUN usermod -a -G sasl Debian-exim
COPY src/exim/exim4_sasl2.conf /usr/lib/sasl2/exim.conf
COPY src/exim/exim4.conf /etc/exim4/exim4.conf

# Cyrus Installation:
RUN  mv  /etc/cyrus.conf  /etc/cyrus.conf.orig &&  \
     mv  /etc/imapd.conf  /etc/imapd.conf.orig 
COPY src/cyrus/cyrus.conf /etc/cyrus.conf
COPY src/cyrus/imapd.conf  /etc/imapd.conf

RUN mkdir -p /var/run/cyrus/socket
RUN chown -R cyrus:mail /var/run/cyrus

RUN usermod -a -G sasl cyrus

## create some default use, cyrus is configured as admin in imapd.conf
#RUN echo "cyrus"|saslpasswd2 -u test -c cyrus -p
#RUN echo "bob"|saslpasswd2 -u test -c bob -p
#RUN echo "alice"|saslpasswd2 -u test -c alice -p
#
# CMD /usr/sbin/cyrmaster


COPY --from=apky-ubik /app/ubik /root/
COPY   src/run.sh /run.sh

EXPOSE 25 143 993
CMD ["/run.sh"]
