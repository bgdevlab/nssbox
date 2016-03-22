#!/bin/sh

ident=`basename "$0"`
logfile="`pwd`/log.$ident"
errlogfile=$logfile
touch $logfile

lognow(){
    #ident="config.security"
    local tstamp=`date +%F\ %H:%M:%S`
    local message="$1"
    echo "$tstamp,$ident,$message" | tee -a $logfile
}


disableSELinux() {

    # DISABLE SELINUX
    # http://www.togotutor.com/forums/shell/194-bash-script-disable-selinux.html
    selinux_config_file=/etc/sysconfig/selinux
    
    lognow "disabling SELinux"
    lognow "making backup to /tmp/"
    cp $selinux_config_file /tmp

    cat << EOF > $selinux_config_file
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
# enforcing - SELinux security policy is enforced.
# permissive - SELinux prints warnings instead of enforcing.
# disabled - SELinux is fully disabled.
SELINUX=disabled
# SELINUXTYPE= type of policy in use. Possible values are:
# targeted - Only targeted network daemons are protected.
# strict - Full SELinux protection.
SELINUXTYPE=targeted
EOF
    su -c '/usr/sbin/setenforce 0'
    
}

disableIPTables() {

    lognow "disabling Firewal (iptables)"
    # DISBALE FIREWALL
    # http://www.linuxnix.com/2011/02/disable-iptables-firewall-redhatcentos-linux.html
    /sbin/service iptables stop
    /sbin/service iptables save
    /sbin/chkconfig --level 123456 iptables off
}


disableSELinux
disableIPTables