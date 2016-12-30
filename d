#!/bin/bash -e


error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}
trap 'error ${LINENO}' ERR


build() {
  docker build -t mail .
}

rebuild() {
  docker build --no-cache -t mail . 
}

run() {
  docker stop mail 2>/dev/null || true
  docker rm mail 2>/dev/null || true
  docker run -d --name mail \
             --volume /etc/localtime:/etc/localtime:ro \
	     --volume /data/mail/config/virtualdomains:/etc/exim4/virtualdomains \
	     --volume /data/mail/config/mailinglists:/etc/exim4/mailinglists \
	     --volume /data/mail/config/dnslists:/etc/exim4/dnslists \
	     --volume /data/mail/config/rblwhitelist:/etc/exim4/rblwhitelist \
             --volume /data/mail/tmp:/tmp \
             --volume /data/mail/spool_imap:/data \
             --security-opt seccomp=unconfined  \
             -p 143:143  \
             -p 993:993  \
             -p 25:25  \
             --hostname mail.scortum.com \
             mail
}

enter() {
  docker exec -it mail bash
}

bash() {
  docker run -it --rm \
             -v /data/mail/tmp:/tmp \
             -v /data/mail/data:/data \
             -v /data/scortum-letsencrypt/certs:/certs \
             -v /etc/localtime:/etc/localtime:ro \
             -p 143:143  \
             -p 993:993  \
             -p 25:25  \
             mail bash
}

adduser()
{
  docker exec -it mail saslpasswd2 -u scortum.com -c $1
}




# Does a cleanup:
# http://www.projectatomic.io/blog/2015/07/what-are-docker-none-none-images/
#

clean() {
  local STOPPED_CONTAINERS=$(docker ps -a -q)
  [[ ${STOPPED_CONTAINERS} ]] && docker rm ${STOPPED_CONTAINERS}
  
  local DANGLING_IMAGES=$(docker images -f "dangling=true" -q)
  [[ ${DANGLING_IMAGES} ]] && docker rmi ${DANGLING_IMAGES}
}

gc() {
 docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc spotify/docker-gc
}


help() {
  declare -F
}

if [[ $@ ]]; then
 "$@"
else
  build
fi



	
