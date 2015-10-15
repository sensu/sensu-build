#!/bin/sh

set -e

[ -d sensu-build ] && cd sensu-build

bundle install

rake clean

rake

mkdir -p /tmp/assets

mv *.deb /tmp/assets || true

mv *.rpm /tmp/assets || true
