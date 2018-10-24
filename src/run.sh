#!/bin/bash

## passwd cyrus
#Changing password for user cyrus.
#New password:
#Retype new password:
#passwd: all authentication tokens updated successfully.

## saslpasswd2 -c cyrus
#Password:
#Again (for verification):

## sasldblistusers2
#cyrus@newhost.example.com: userPassword


echo "Starting everything..."
exec /root/ubik name=syslog           /usr/sbin/rsyslogd -n   \
           ---  name=exim             /usr/sbin/exim -bdf     \
           ---  name=cyrus            /usr/sbin/cyrmaster -D  \
           ---  name=logtail pause=5  /usr/bin/tail -f /var/log/syslog
