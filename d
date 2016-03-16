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
  docker stop mail || true
  docker rm mail || true
  docker run -d --name mail \
             -v /data/mail/tmp:/tmp \
             -v /data/mail/data:/data \
             -v /data/scortum-letsencrypt/certs:/certs \
             -v /etc/localtime:/etc/localtime:ro \
             -p 143:143  \
             -p 993:993  \
             -p 25:25  \
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





# Does a cleanup:
# http://www.projectatomic.io/blog/2015/07/what-are-docker-none-none-images/
#

clean() {
  local STOPPED_CONTAINERS=$(docker ps -a -q)
  [[ ${STOPPED_CONTAINERS} ]] && docker rm ${STOPPED_CONTAINERS}
  
  local DANGLING_IMAGES=$(docker images -f "dangling=true" -q)
  [[ ${DANGLING_IMAGES} ]] && docker rmi ${DANGLING_IMAGES}
}

help() {
  declare -F
}

if [[ $@ ]]; then
 "$@"
else
  build
fi



	
