#!/usr/bin/env bash
# see https://gist.github.com/theodson/ed84e9c80c97ca8af53a

time curl https://gist.githubusercontent.com/theodson/ed84e9c80c97ca8af53a/raw/adc9c8188cadd7baff126a329d18858953294ab9/getOracleJDK.sh | bash -s "rpm" "6" 2>/dev/null \
    && yum -y localinstall --nogpgcheck jdk-6u*-linux-x64*rpm* \
    && rm -f jdk-6u*-linux-x64*rpm*


sudo rm -f /usr/java/default
sudo ln -s /usr/java/jdk1.6* /usr/java/default

priority=65

## java ##
sudo -i /usr/sbin/alternatives --install /usr/bin/java java /usr/java/jdk1.6.0_*/jre/bin/java $priority
sudo -i /usr/sbin/alternatives --set java /usr/java/jdk1.6.0_*/jre/bin/java

## javaws ##
sudo -i /usr/sbin/alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.6.0_*/jre/bin/javaws $priority
sudo -i /usr/sbin/alternatives --set javaws /usr/java/jdk1.6.0_*/jre/bin/javaws

## jcontrol
sudo -i /usr/sbin/alternatives --install /usr/bin/jcontrol jcontrol /usr/java/jdk1.6.0_*/jre/bin/jcontrol $priority
sudo -i /usr/sbin/alternatives --set jcontrol /usr/java/jdk1.6.0_*/jre/bin/jcontrol

## javadoc
sudo -i /usr/sbin/alternatives --install /usr/bin/javadoc javadoc /usr/java/jdk1.6.0_*/bin/javadoc $priority
sudo -i /usr/sbin/alternatives --set javadoc /usr/java/jdk1.6.0_*/bin/javadoc

## Install javac only if you installed JDK (Java Development Kit) package ##
sudo -i /usr/sbin/alternatives --install /usr/bin/javac javac /usr/java/jdk1.6.0_*/bin/javac $priority
sudo -i /usr/sbin/alternatives --set javac /usr/java/jdk1.6.0_*/bin/javac

sudo -i /usr/sbin/alternatives --install /usr/bin/jar jar /usr/java/jdk1.6.0_*/bin/jar $priority
sudo -i /usr/sbin/alternatives --set jar /usr/java/jdk1.6.0_*/bin/jar

rm -f jdk-6u*.rpm jdk-6u*.bin sun-javadb-*