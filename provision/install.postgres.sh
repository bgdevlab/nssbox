#!/usr/bin/env bash

ident=`basename "$0"`
logfile="`pwd`/log.$ident"
errlogfile=$logfile
touch $logfile

lognow(){
    #ident="install.postgres"
    local tstamp=`date +%F\ %H:%M:%S`
    local message="$1"
    echo "$tstamp,$ident,$message" | tee -a $logfile
}


installPostgres() {

    yum -y install postgresql-server 
    # POSTGRES
    data_postgresql_initdb=/var/lib/pgsql/data

    lognow "initialise database"
    su postgres -c "initdb -D $data_postgresql_initdb"

    # Standard YUM installed services.
    lognow "install postgresql service"
    /sbin/chkconfig postgresql on
    /sbin/service postgresql status

    lognow "TODO: NEED TO INIT POSTGRES"

    lognow "configuring postgresql"
    pgsql_conf="/var/lib/pgsql/data/postgresql.conf"
    pgsql_hba_conf="/var/lib/pgsql/data/pg_hba.conf"
    if [ -e "$pgsql_conf" ]; then
        lognow ".. setting listening on all ports"
        sudo su -c "echo listen_addresses=\'*\' >> /var/lib/pgsql/data/postgresql.conf"
        lognow ".. setting permistted external accecss ip range"
        sudo su -c "echo host all all 10.20.0.0/16 trust >> /var/lib/pgsql/data/pg_hba.conf"
        /sbin/service postgresql restart
    else
        lognow "ERROR:can not find postgresql file ($pgsql_conf)"
    fi
    
}

installPostgres  
exit 0