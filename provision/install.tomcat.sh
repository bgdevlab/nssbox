#!/usr/bin/env bash

time curl --silent --show-error  -O https://raw.githubusercontent.com/bgdevlab/centos-util/os/5/scripts/install.tomcat.sh && chmod +x install.tomcat.sh
time ./install.tomcat.sh

