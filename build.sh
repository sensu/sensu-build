#!/bin/sh

system=unknown
if [ -f /etc/redhat-release ]; then
    system=redhat
elif [ -f /etc/debian_version ]; then
    system=debian
elif [ -f /etc/SuSE-release ]; then
    system=suse
elif [ -f /etc/gentoo-release ]; then
    system=gentoo
elif [ -f /etc/arch-release ]; then
     system=arch
elif [ -f /etc/slackware-version ]; then
    system=slackware
elif [ -f /etc/lfs-release ]; then
    system=lfs
fi

install_epel() {
    cat > /etc/yum.repos.d/epel.repo << EOF
[epel]
name=epel
baseurl=http://download.fedoraproject.org/pub/epel/\$releasever/\$basearch
enabled=1
gpgcheck=0
EOF
}

install_bunchr() {
    gem install bunchr --no-rdoc --no-ri
}

## install platform specific build dependencies
case "$system" in
    redhat)
        yum clean all
        install_epel
        yum -y install git rpm-build curl
        install_bunchr
    ;;

    debian)
        apt-get -y install git-core curl m4 g++ make gcc
        install_bunchr
    ;;

    suse)
        zypper --non-interactive install git-core curl m4 make gcc gcc-c++
        install_bunchr
    ;;

    *)
        echo "WARNING: I don't recognize system [$system]. Going to try to" \
             "build without installing any dependencies anyway."
esac


## run Rakefile to build packages
rake clean
rake
