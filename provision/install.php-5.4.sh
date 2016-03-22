#!/usr/bin/env bash

ident=`basename "$0"`
logfile="`pwd`/log.$ident"
errlogfile=$logfile
touch $logfile

lognow(){
    #ident="install.php-5.4"
    local tstamp=`date +%F\ %H:%M:%S`
    local message="$1"
    echo "$tstamp,$ident,$message" | tee -a $logfile
}


installPhp() {

    lognow "## add php-5.4, pear and pecl ##"
    yum -y --enablerepo=remi install php \
        php-cli php-devel php-pear php-pdo php-mysqlnd php-pgsql php-sqlite php-gd php-intl php-mbstring php-process \
        php-mcrypt php-xml php-pecl-apc php-pecl-amqp php-pecl-json php-pecl-jsonc php-pecl-redis php-pecl-ssh2 \
        php-pecl-memcache php-pecl-memcached

    lognow "## add phing, dbunit, stomp ##"
    yum -y --enablerepo=remi install php-channel-phing
    yum -y --enablerepo=remi install php-channel-phpunit
    yum -y --enablerepo=remi install php-pear-phing
    yum -y --enablerepo=remi install php-phpunit-DbUnit
    yum -y --enablerepo=remi install php-phpunit-PHPUnit-Selenium

    lognow "## add PEAR GIT and SVN ##"
    pear install VersionControl_GIT-alpha VersionControl_SVN-alpha
 
 }


installStomp() {

    lognow "## add PEAR Stomp ##"
    # pecl stomp demands user interaction - the line below replies with an 'return' to accept the default openssl location.
    echo "no" > tmp_stomp_answer
    echo "pecl install stomp < tmp_stomp_answer" > tmp_install_pecl.sh
    chmod +x tmp_install_pecl.sh
    lognow "About to run PECL Install tmp_install_pecl.sh"
    ./tmp_install_pecl.sh
}

configurePhp() {

    phpini="/etc/php.ini"

    # configure PHP arguments php.ini

    lognow "Configure $phpini"
    echo "date.timezone = \"Australia/NSW\"" >> $phpini
    echo "max_execution_time = 1800     ; Maximum execution time of each script, in seconds" >> $phpini

	echo "extension=stomp.so" >> $phpini

    sed -i s/^memory_limit/\;\ memory_limit/g $phpini
    echo "memory_limit = 512M" >> $phpini

    sed -i s/^upload_max_filesize/\;\ upload_max_filesize/g $phpini
    echo "upload_max_filesize = 4M" >> $phpini

    cat << EOF >> $phpini
xdebug.max_nesting_level=250
xdebug.remote_enable=1
;xdebug.remote_host="YOUR CLIENT DEV IP ADDRESS"
xdebug.remote_host="127.0.0.1"
xdebug.remote_port=9000
xdebug.idekey="PHPSTORM"
EOF

}



installSupportingTools() {
    # we often use inotify with rsync to sync between vagrant mounts and real folders.
    yum --enablerepo=epel -y install inotify-tools
}

cleanup() {
    rm -f tmp_stomp_answer && rm -f tmp_install_pecl.sh
}


installPhp
installStomp
configurePhp
installSupportingTools
cleanup

exit 0











uninstallPear() {

    lognow "uninstalling pear and pecl "
    pear clear-cache
    yum erase php-pear -y
    # tidy files
    rm -rf /usr/share/pear /usr/bin/pear /usr/bin/pecl /etc/pear.conf /usr/bin/peardev /root/.pearrc;
    rm -rf /usr/docs/phing

    rm -f /usr/local/bin/pear
    rm -f /usr/bin/pear;
    updatedb;
    locate pear;
}

uninstallPeclModules() {

    lognow "installing pecl packages"
    pecl uninstall xdebug
    pecl uninstall stomp
    # tidy files
    rm -f /usr/bin/pecl ;
    rm -f /usr/local/bin/pecl
    updatedb;
}

