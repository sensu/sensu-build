#!/bin/sh


version=$1
iteration=$2

if [ -z $iteration ] || [ -z $version ]; then
    echo "Usage: $0 version iteration"
    exit 1
fi

## yum ##

for arch in x86_64 i386; do
    rpm_name="sensu-${version}-${iteration}.${arch}.rpm"

    scp $rpm_name  joemiller.me:/var/www/sensu.joemiller.me/html/yum/el/5/${arch}/

    # we have an el-5 and el-6 repo but we're currently using the same rpm's in both

    ssh joemiller.me "cp /var/www/sensu.joemiller.me/html/yum/el/5/${arch}/$rpm_name \
                         /var/www/sensu.joemiller.me/html/yum/el/6/${arch}/$rpm_name"
done

ssh joemiller.me "/var/www/sensu.joemiller.me/yum_update.sh"


## apt ##
for arch in amd64 i386; do
    deb_name="sensu_${version}-${iteration}_${arch}.deb"

    scp $deb_name joemiller.me:

    ssh joemiller.me "/var/www/sensu.joemiller.me/apt_update.sh ~/${deb_name}"
done
