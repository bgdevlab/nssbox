#!/usr/bin/env bash

if [ -e /etc/redhat-release ] && [ "$1" == "grow" ] ; then

    # On the GUEST

    # https://ma.ttias.be/increase-a-vmware-disk-size-vmdk-formatted-as-linux-lvm-without-rebooting/
    # http://superuser.com/questions/332252/creating-and-formating-a-partition-using-a-bash-script
    if [ ! -e fdisk_done ]; then
        fdisk /dev/sda <<EOF
n
p
3


t
3
8e
w
EOF
        touch fdisk_done
        exit
    fi

    pvcreate /dev/sda4
    vlg=$(vgdisplay | grep 'VG Name'| sed 's/[[:space:]]//g' | sed 's/VGName//')
    vgextend $vlg /dev/sda4
    pvscan
    lvextend /dev/${vlg}/LogVol00 /dev/sda4
    resize2fs /dev/${vlg}/LogVol00
    rm -f fdisk_done
    df -h
fi

hddsize=120

if [[ "$OSTYPE" == "darwin"* ]]; then
    # On the HOST

    if [ "$1" == "vb" ]; then

        vagrant halt

        # http://stackoverflow.com/questions/11659005/how-to-resize-a-virtualbox-vmdk-file

        buildvm_id=$(echo $(VBoxManage list vms | grep $(cat .vagrant/machines/default/virtualbox/id)) | cut -d '"' -f 2)
        buildhdd_uuid=$(VBoxManage list hdds | grep -F5 $buildvm_id | grep '^UUID'|cut -d ':' -f 2- | sed 's/ //g')
        buildhdd_path=/$(VBoxManage list hdds | grep -F5 $buildvm_id | grep '^Location'|cut -d '/' -f 2- | head -1)

        pushd ~/VirtualBox*VMs/${buildvm_id}
        echo -e "buildvm_id    : ${buildvm_id}\nbuildhdd_uuid : ${buildhdd_uuid}\nbuildhdd_path : ${buildhdd_path}\n"

        ls "$buildhdd_path"

        echo "VBoxManage clonehd \"${buildhdd_path}\""
        VBoxManage clonehd "${buildhdd_path}" "cloned.vdi" --format vdi

        echo "VBoxManage modifyhd $((1024 * $hddsize))"
        VBoxManage modifyhd "cloned.vdi" --resize "$((1024 * $hddsize))"

        {
            # remove original DISK from VM and archive it just in case.
            echo "Detach original storage ${buildvm_id}"
            VBoxManage storageattach "${buildvm_id}" --medium none --storagectl "SATA Controller" --port 0
            if [ $? -eq 0 ]; then
                echo "Close disk medium and move original vmdk file for ${buildhdd_uuid}"
                VBoxManage closemedium disk "${buildhdd_uuid}" && mv "${buildhdd_path}" "${buildhdd_path}_original"
            fi
        }

        if [ $? -eq 0 ]; then

            # Attach newly resized HD
            VBoxManage clonehd cloned.vdi "${buildhdd_path}" --format vmdk && VBoxManage storageattach "${buildvm_id}" \
                --medium "${buildhdd_path}" --storagectl "SATA Controller" --port 0 --type hdd

            # Look for clone hdd and close the medium
            clonehdd_uuid=$(VBoxManage list hdds | grep -B4 $buildvm_id | grep -B4 'clone.vdi' | grep '^UUID' | head -1 | cut -d ':' -f 2- | sed 's/ //g')
            VBoxManage closemedium disk "${clonehdd_uuid}"

            echo -e "Restart the VM without provisioning\nRun the commands $0 grow in the GUEST CentOS VM"
            echo -e "\n You might want to remove '${buildhdd_path}_original' before packaging"
        fi

    elif [ "$1" == "vm" ]; then

        vagrant halt

        "/Applications/VMware Fusion.app/Contents/Library/vmware-vdiskmanager" -x ${hddsize}Gb .vagrant/machines/default/vmware_fusion/*-*-*-*-*/disk.vmdk
        echo "Restart the VM without provisioning"
        echo "Run the commands $0 grow in the GUEST CentOS VM"

    fi


fi
