#!/usr/bin/env bash

ident=`basename "$0"`
logfile="`pwd`/log.$ident"
errlogfile=$logfile
touch $logfile

lognow(){
    #ident="install.scm"
    local tstamp=`date +%F\ %H:%M:%S`
    local message="$1"
    echo "$tstamp,$ident,$message" | tee -a $logfile
}


installSubversion17() {
    # https://github.com/yahoo-bot/distributions/blob/master/svn1.7_centos6_wandisco.sh
    lognow " remove old subversion"
    yum remove subversion*

    lognow "Importing GPG key"
    wget http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco -O /tmp/RPM-GPG-KEY-WANdisco &>/dev/null
    su -c 'rpm --import /tmp/RPM-GPG-KEY-WANdisco'
    rm -rf /tmp/RPM-GPG-KEY-WANdisco

    grep 'CentOS' /etc/redhat-release
    CENTOS=$?

    uname -r | grep 'el5' 2>&1 > /dev/null
    RHELV5=$?

    lognow "install neon to satisfy svn's neon dependency requirement"
    yum -y install neon
        
    if [ $RHELV5 -eq 0 ]; then
        wget http://opensource.wandisco.com/centos/5/devel/RPMS/x86_64/subversion-1.7.13-1.x86_64.rpm
    else
        lognow "Assuming RHEL 6 as we could not find RHEL 5"
        if [ $CENTOS -eq 0 ];then
            wget http://opensource.wandisco.com/centos/6/svn-1.7/RPMS/x86_64/subversion-1.7.13-1.x86_64.rpm
        else
            lognow "Assuming RHEL distro as could not find CentOS"
            wget http://opensource.wandisco.com/rhel/6/svn-1.7/RPMS/x86_64/subversion-1.7.13-1.x86_64.rpm
        fi
    fi

    lognow " Installing subversion-1.7.13-1.x86_64.rpm"
    rpm -ivh subversion-1.7.13-1.x86_64.rpm

    lognow " ------ Installing yum repo: Done ------"
}


installSubversion() {
    lognow "..installing VersionControl tools"
    # Install SVN
    yum install -y subversion-*
}

installGit() {

    # Install GIT DVCS
    yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc
    # https://fedoraproject.org/keys
    # http://serverfault.com/questions/81362/how-to-install-git-to-red-hat-enterprise-linux-5-3-x64

    # Install GIT
    cat > rhel-epel.repo << EOM
[rhel-epel]
name=Extra Packages for Enterprise Linux \$releasever - \$basearch
baseurl=http://download3.fedora.redhat.com/pub/epel/\$releasever/\$basearch
enabled=1
gpgcheck=0
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
EOM
    su -c 'cp rhel-epel.repo /etc/yum.repos.d/rhel-epel.repo'
    #touch /etc/yum.repos.d/rhel-epel.repo
    #cp rhel-epel.repo /etc/yum.repos.d/rhel-epel.repo
    #wget --no-check-certificate https://fedoraproject.org/static/217521F6.txt -O RPM-GPG-KEY-EPEL
    #rpm --import RPM-GPG-KEY-EPEL
    yum install -y git
}

cleanup() {
    rm -f subversion-1.7.13-1.x86_64.rpm
}


#installSubversion17
installGit
cleanup