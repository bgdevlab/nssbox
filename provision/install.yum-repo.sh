#!/usr/bin/env bash

ident=`basename "$0"`
logfile="`pwd`/log.$ident"
errlogfile=$logfile
touch $logfile

lognow(){
    #ident="install.yum-repo.rhel5"
    local tstamp=`date +%F\ %H:%M:%S`
    local message="$1"
    echo "$tstamp,$ident,$message" | tee -a $logfile
}


installYumRepos() {
    
    # Based on guide at http://www.if-not-true-then-false.com/2010/install-apache-php-on-fedora-centos-red-hat-rhel/
    # and tweaked from http://serverfault.com/questions/456968/how-do-i-upgrade-to-the-latest-php-version-in-centos-with-yum

    lognow "## Adding Remi Dependency on CentOS 5 and Red Hat (RHEL) 5 ##"
    wget http://download.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
    rpm -Uvh epel-release-5-4.noarch.rpm

    lognow "# CentOS 5 and Red Hat (RHEL) 5 ##"
    wget http://rpms.famillecollet.com/enterprise/remi-release-5.rpm
    rpm -Uvh remi-release-5.rpm

    # http://serverfault.com/questions/481798/installing-php-5-4-11-on-centos-6-3?rq=1
    lognow "clean yum and update prior to PHP install"
    yum -y clean all
    yum -y --obsoletes update

}

cleanup() {
    rm -f remi-release-5.rpm epel-release-5-4.noarch.rpm
}

installYumRepos
cleanup