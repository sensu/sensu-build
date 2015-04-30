#!/bin/sh

set -e

## utilize chef's ruby
export PATH=/opt/chef/embedded/bin:$PATH

## install gem dependencies
bundle install
## run Rakefile to build packages
rake clean
rake
