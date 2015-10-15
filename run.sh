#!/bin/sh

set -e

[ -d sensu-build ] && cd sensu-build

bundle install

rake clean

rake
