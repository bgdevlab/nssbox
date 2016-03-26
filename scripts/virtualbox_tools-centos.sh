#!/usr/bin/env bash
HOME_DIR="${HOME_DIR:-/home/vagrant}";

update_virtualbox_tools() {

    echo "[virtualbox tools] prepare: START"

    # yum -y group install 'Development Tools'
    yum -y install kernel-devel gcc perl
}

yum -y install dmidecode;

# check we are running in virtualbox
dmidecode -s system-product-name | grep -i 'virtualbox'
if [ $? -eq 0 ]; then
    update_virtualbox_tools
else
    echo "Skipping virtualbox vagrant-vbguest required updates"
fi




