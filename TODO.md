

## Setup paswd

  # passwd cyrus
  Changing password for user cyrus.
  New password:
  Retype new password:
  passwd: all authentication tokens updated successfully.

  # saslpasswd2 -c cyrus
  Password:
  Again (for verification):

  # sasldblistusers2
  cyrus@newhost.example.com: userPassword



## start sasl and cyrus


  /etc/default/saslauthd  => START=yes


  service saslauthd start


  service cyrus-imapd start




## get cert

https://letsencrypt.org/




## fix /etc/imapd.conf


  sasl_pwcheck_method: auxprop  #saslauthd  #auxprop
  sasl_auxprop_plugin: sasldb



