# nssbox

The scripts that build the bgdevlab development environment.



| Release     | Branch    | CentOS Version  |
| ----------- | --------- | --------------- |
| 1.0         | os/5      | CentOS 5.x      |
| 2.0         | master    | CentOS 6.x      |

## Included Software

* CentOS 5.11
* Git
* PHP 5.x.45
* Apache 2.2.x
* Postgresql 8.1
* Composer
* Phing 2.14
* Tomcat 6.0.18
* ActiveMQ 5.10.2
* Java 1.6.0_45
* Java 1.8.0_73

## Build

## 1. Build Box
Build environment is OSX.

To build the VirtualBox Vagrant box

    ./build.sh vb   

To build the VMWare Vagrant box

    ./build.sh vm 

## 2. Expand Disk Size

As this VM is based on the `bento` VM's the default disk size in _40 Gb_. To expand the size see below. 

In the host environment, OSX run

To expand the VirtualBox Vagrant box

    scripts/expand.storage.sh vb
    vagrant ssh

To expand the VMWare Vagrant box
    
    scripts/expand.storage.sh vm
    vagrant ssh
    
In the guest environment

    sudo su -
    /vagrant/scripts/expand.storage.sh grow
    
The script will reboot the VM, login once VM available

    vagrant ssh
    sudo su -
    /vagrant/scripts/expand.storage.sh grow

This completes the expansion process, check available size with `df -h`.         

## 3. Package Box

To package the VirtualBox VM into a Vagrant box

    ./package.sh vb   

To package the VMWare VM into a Vagrant box

    ./package.sh vm 

