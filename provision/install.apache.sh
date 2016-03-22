#!/usr/bin/env bash

ident=`basename "$0"`
logfile="`pwd`/log.$ident"
errlogfile=$logfile
touch $logfile

lognow(){
    #ident="install.apache"
    local tstamp=`date +%F\ %H:%M:%S`
    local message="$1"
    echo "$tstamp,$ident,$message" | tee -a $logfile
}


installApache() {

    local tstamp=`date +%F-\%H:%M:%S`

    yum -y install httpd mod_ssl trickle ifstatus iftop
    # APACHE
    lognow "configuring apache"
    mkdir /etc/httpd/vhosts
    mkdir -p /opt/projects/DEMO/site/www
    chmod 777 /opt/projects/DEMO/site/www
    echo "install DEMO <a href='check.php'> Check PHP</a>" > /opt/projects/DEMO/site/www/index.html
    echo "<?php echo phpinfo();?>" > /opt/projects/DEMO/site/www/check.php
    cp /etc/httpd/conf/httpd.conf "/tmp/httpd.conf.$tstamp"
    sudo su -c 'echo "NameVirtualHost *:80" >> /etc/httpd/conf/httpd.conf'
    sudo su -c 'echo "include vhosts/*.conf" >> /etc/httpd/conf/httpd.conf'
    hostname=`hostname`
    httpd_vhost_conf="/etc/httpd/vhosts/vhost1.conf"
    lognow "creating virtual-host $httpd_vhost_conf"

    cat << EOF > "local-vhost.conf"
<VirtualHost *:80>
    ServerName $hostname 
    <Directory "/opt/projects/DEMO/site/www">
        Order allow,deny
        Allow from all
    </Directory>
    DocumentRoot /opt/projects/DEMO/site/www
    php_value include_path "/opt/projects/DEMO/site/include"
</VirtualHost>






EOF
    sudo su -c 'cp local-vhost.conf /etc/httpd/vhosts/demo.conf'
    sudo su -c 'chown apache:apache /etc/httpd/vhosts/demo.conf'
    
    echo "# fix virtualbox smallfile cache issue of shared folders #"
    echo "EnableSendfile off" >> /etc/httpd/conf/httpd.conf
    
    lognow "install httpd service"
    /sbin/chkconfig httpd on

}

installApache