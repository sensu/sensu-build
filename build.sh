#!/bin/sh

set -e

[ -d sensu-build ] && cd sensu-build

commit=`git rev-parse HEAD`

if [ $(git describe --exact-match $commit) ]; then
    echo 'Found build tag for commit.'
    echo 'Building packages ...'

    version=`git describe --abbrev=0 --tags | awk -F'-' '{print $1}'`
    iteration=`git describe --abbrev=0 --tags | awk -F'-' '{print $2}'`

    export SENSU_VERSION=$version
    export BUILD_NUMBER=$iteration

    ./docker_build.sh $1
else
    echo 'Missing build tag for commit.'
    echo 'Not building packages.'

    exit 0
fi
