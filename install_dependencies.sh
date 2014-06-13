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

## install ruby, using rvm ... there be dragons
install_ruby() {
    if ! type gem > /dev/null; then
        curl -L get.rvm.io | bash -s stable
        /bin/bash --login -c ' \
          source /etc/profile.d/rvm.sh ; \
          rvm install 2.1.2 ; \
          rvm --default use 2.1.2
        '
    fi
}

## install platform specific build dependencies
case "$system" in
    redhat)
        yum clean all
        install_epel
        yum -y install curl m4 make gcc gcc-c++ rpm-build
        install_ruby
        ;;

    debian)
        apt-get update
        apt-get -y install curl m4 g++ make gcc
        install_ruby
        ;;

    suse)
        zypper --non-interactive install curl m4 make gcc gcc-c++
        install_ruby
        ;;

    *)
        echo "WARNING: I don't recognize system [$system]. Going to try to" \
            "build without installing any dependencies anyway."
esac
