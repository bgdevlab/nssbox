#!/usr/bin/env bash

ident=`basename "$0"`
logfile="`pwd`/log.$ident"
errlogfile=$logfile
touch $logfile

lognow(){
    #ident="install.linux.core"
    local tstamp=`date +%F\ %H:%M:%S`
    local message="$1"
    echo "$tstamp,$ident,$message" | tee -a $logfile
}


installCore() {
    
    su -c 'echo "export HISTTIMEFORMAT=\"%h/%d - %H:%M:%S \""  >> /etc/bashrc'

    lognow "installing yum standard packages"
    yum install -y openconnect \
        perl-DBI perl-DBD-Pg ntp nmap gcc sendmail sendmail-cf m4 telnet dos2unix vim-enhanced \
        curl curl-devel gcc gcc-c++ autoconf automake mutt yum-downloadonly yum-utils mlocate htop man nano \
        setuptool system-config-network*  system-config-firewall* system-config-securitylevel-tui  system-config-keyboard ntsysv bind-utils \
        tree traceroute

    lognow "install ntpd service"
    /sbin/chkconfig ntpd on

}

cleanup() {
    lognow "cleanup $0"
}

installCore
cleanup
exit 0
