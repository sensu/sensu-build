#!/bin/sh

## install gem dependencies
bundle install
## run Rakefile to build packages
rake clean
rake
