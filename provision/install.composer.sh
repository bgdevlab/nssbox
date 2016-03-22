#!/usr/bin/env bash

ident=`basename "$0"`
logfile="`pwd`/log.$ident"
errlogfile=$logfile
touch $logfile

lognow(){
    #ident="install.composer"
    local tstamp=`date +%F\ %H:%M:%S`
    local message="$1"
    echo "$tstamp,$ident,$message" | tee -a $logfile
}


installComposer() {

    lognow "install composer application"
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/
	ln -s /usr/bin/composer.phar /usr/bin/composer
}

cleanup() {
    lognow "cleanup composer - nothing to do"
}

installComposer
cleanup

