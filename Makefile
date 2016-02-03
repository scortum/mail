
build:
	docker build -t mail .


run:
	docker run -it --rm \
        	   -v /etc/localtime:/etc/localtime:ro \
	           -v /home/core/mail/src/tmp:/tmp \
        	   mail bash

.PHONY: build run

