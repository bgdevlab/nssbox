#!/usr/bin/env bash
# see https://gist.github.com/theodson/ed84e9c80c97ca8af53a

time curl https://gist.githubusercontent.com/theodson/ed84e9c80c97ca8af53a/raw/b6f35bf5092955e37117f0a80da89be09321594b/getOracleJDK.sh | bash -s "rpm" 2>/dev/null \
    && yum -y localinstall --nogpgcheck jdk-8u*-linux-x64*.rpm* \
    && rm -f jdk-8u*-linux-x64*.rpm*

