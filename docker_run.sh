#!/bin/sh

set -e

[ -d sensu-build ] && cd sensu-build

bundle install

rake clean
rake

mkdir -p /tmp/assets/pkg

mv *.deb /tmp/assets/pkg || true
mv *.rpm /tmp/assets/pkg || true
