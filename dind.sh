#!/bin/sh

set -e

env="-e SENSU_VERSION=$SENSU_VERSION -e BUILD_NUMBER=$BUILD_NUMBER"

vol="-v `pwd`:/sensu-build -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker"

run="./sensu-build/build.sh `pwd`"

docker run --rm $env $vol ubuntu:14.04 $run
