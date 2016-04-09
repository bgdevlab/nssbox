#!/usr/bin/env bash
# see https://gist.github.com/theodson/ed84e9c80c97ca8af53a

function download_install_jdk() {
    # get the Oracle JDK
    time curl https://gist.githubusercontent.com/theodson/ed84e9c80c97ca8af53a/raw/adc9c8188cadd7baff126a329d18858953294ab9/getOracleJDK.sh | bash -s "rpm" "6" 2>/dev/null \
        && echo "Download JDK6 complete" \
        && chmod +x jdk-6u*-linux-x64*rpm* \
        && sudo ./jdk-6u*-linux-x64*rpm.bin
    jdk_dir=$(basename /usr/java/jdk1.6*)
    sudo rm -f /usr/java/default
    sudo ln -s "/usr/java/${jdk_dir}" /usr/java/default
}

function configure_alternatives() {
    priority=65

    jdk_dir=$(basename /usr/java/jdk1.6*)

    for cmd in javac javadoc jar
    do
        #echo "configuring ${cmd} against ${jdk_dir}"

        [ -e /etc/alternatives/${cmd} ] && rm -f /etc/alternatives/${cmd}
        ln -s  "/usr/java/${jdk_dir}/bin/${cmd}" /etc/alternatives/

        [ -e /usr/bin/${cmd} ] && rm -f /usr/bin/${cmd}
        ln -s  "/usr/java/default/bin/${cmd}" /usr/bin/
        /usr/sbin/alternatives --install /usr/bin/${cmd} ${cmd} /usr/java/${jdk_dir}/bin/${cmd} $priority
        /usr/sbin/alternatives --set ${cmd} /usr/java/${jdk_dir}/bin/${cmd}

    done

    for cmd in java javaws jcontrol
    do
        #echo "configuring ${cmd} for jre against ${jdk_dir}"

        [ -e /etc/alternatives/${cmd} ] && rm -f /etc/alternatives/${cmd}
        ln -s  "/usr/java/${jdk_dir}/jre/bin/$cmd" /etc/alternatives/$cmd

        [ -e /usr/bin/${cmd} ] && rm -f /usr/bin/${cmd}
        ln -s  "/usr/java/default/jre/bin/$cmd" /usr/bin/$cmd

        sudo /usr/sbin/alternatives --install /usr/bin/${cmd} ${cmd} /usr/java/${jdk_dir}/jre/bin/${cmd} $priority
        sudo /usr/sbin/alternatives --set ${cmd} /usr/java/${jdk_dir}/jre/bin/${cmd}
    done

    #rm -f /etc/alternatives/{java,javac,jar,javadoc,javaws,jcontrol} /usr/bin/{java,javac,jar,javadoc,javaws,jcontrol}
}


download_install_jdk
configure_alternatives

ls -l /etc/alternatives/j* /usr/bin/j*

rm -f jdk-6u*.rpm jdk-6u*.bin sun-javadb-*
