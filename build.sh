#!/bin/sh

set -e

docker build -f dockerfiles/Debian -t sensu-build-debian .

docker build -f dockerfiles/CentOS -t sensu-build-centos .

cwd=`pwd`

docker run --rm -e "SENSU_VERSION=$SENSU_VERSION" -e "BUILD_NUMBER=$BUILD_NUMBER" -v $cwd:/sensu-build sensu-build-debian ./sensu-build/run.sh

docker run --rm -e "SENSU_VERSION=$SENSU_VERSION" -e "BUILD_NUMBER=$BUILD_NUMBER" -v $cwd:/sensu-build sensu-build-centos ./sensu-build/run.sh
