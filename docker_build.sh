#!/bin/sh

set -e

[ -d sensu-build ] && cd sensu-build

tar -cvf archive.tar *

docker build -f dockerfiles/debian-i386 -t sensu-build-debian-i386 .
docker build -f dockerfiles/debian-amd64 -t sensu-build-debian-amd64 .
docker build -f dockerfiles/centos-i386 -t sensu-build-centos-i386 .
docker build -f dockerfiles/centos-x86_64 -t sensu-build-centos-x86_64 .

env="-e SENSU_VERSION=${SENSU_VERSION-0.20.6} -e BUILD_NUMBER=${BUILD_NUMBER-1}"
vol="-v ${1-/tmp/assets}:/tmp/assets"
run='./sensu-build/docker_run.sh'

docker run --rm $env $vol sensu-build-debian-i386 $run
docker run --rm $env $vol sensu-build-debian-amd64 $run
docker run --rm $env $vol sensu-build-centos-i386 $run
docker run --rm $env $vol sensu-build-centos-x86_64 $run
