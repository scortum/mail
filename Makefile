
build:
	docker build -t mail .


run:
	docker run -it --rm \
           -v /etc/localtime:/etc/localtime:ro \
           -v /home/core/mail/src/tmp:/tmp \
           -p 143:143  \
           -p 993:993  \
           -p 25:25  \
           mail bash

.PHONY: build run

