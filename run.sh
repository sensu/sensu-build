#!/bin/sh

set -e

cd sensu-build

bundle install

rake clean

rake
