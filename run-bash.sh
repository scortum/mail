#!/bin/bash


docker run -it --rm \
           -v /etc/localtime:/etc/localtime:ro \
           -v /home/core/var-mail:/tmp \
           mail bash
