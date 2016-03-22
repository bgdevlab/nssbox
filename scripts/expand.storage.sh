#!/usr/bin/env bash

if [ -e /etc/redhat-release ] && [ "$1" == "grow" ] ; then

    # On the GUEST

    # https://ma.ttias.be/increase-a-vmware-disk-size-vmdk-formatted-as-linux-lvm-without-rebooting/
    # http://superuser.com/questions/332252/creating-and-formating-a-partition-using-a-bash-script
    fdisk /dev/sda <<EOF
n
p
3


t
3
8e
w
EOF
    pvcreate /dev/sda3
    vlg=$(vgdisplay | grep 'VG Name'| sed 's/[[:space:]]//g' | sed 's/VGName//')
    vgextend $vlg /dev/sda3
    pvscan
    lvextend /dev/${vlg}/LogVol00 /dev/sda3
    resize2fs /dev/${vlg}/LogVol00

fi



if [ isOSX ]; then
    # On the HOST

    if [ "$1" == "vb" ]; then

        vagrant halt
        # http://stackoverflow.com/questions/11659005/how-to-resize-a-virtualbox-vmdk-file

        buildvm=`ls ~/VirtualBox\ VMs/ | grep $(basename $(pwd))`
        pushd ~/VirtualBox\ VMs/${buildvm}
        VBoxManage clonehd *.vmdk "cloned.vdi" --format vdi
        VBoxManage modifyhd "cloned.vdi" --resize 286720
        VBoxManage clonehd cloned.vdi centos-7.2-x86_64-disk_1.vmdk --format vmdk

        echo "# Manually remove old HD (*disk1.vmdk) and then new HD (*disk_1.vmdk)"

    elif [ "$1" == "vm" ]; then

        "/Applications/VMware Fusion.app/Contents/Library/vmware-vdiskmanager" -x 240Gb .vagrant/machines/default/vmware_fusion/*-*-*-*-*/disk.vmdk

    fi

    echo "Restart the VM without provisioning"
    echo "Run the commands $0 grow in the GUEST CentOS VM"

fi