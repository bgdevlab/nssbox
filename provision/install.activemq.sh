#!/usr/bin/env bash

time curl --silent --show-error -O https://raw.githubusercontent.com/bgdevlab/centos-util/os/5/scripts/install.activemq.sh && chmod +x install.activemq.sh
time ./install.activemq.sh install amq510
time ./install.activemq.sh clean amq510


