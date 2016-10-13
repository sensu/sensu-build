Sensu packages, build suite
===========================

This repo contains the tool set needed to build Sensu packages for all
currently supported platforms. The builds are 'omnibus' style packages
that contain everything they need to run, including their own build of
Ruby and all required gems.

The build suite relies heavily on Docker, Bunchr and FPM.

Docker containers are used to build packages native to each OS. E.g:
.rpm's on CentOS, and .deb's on Debian. Bunchr allows the same scripts
to be used on each platform so builds are as consistent as possible
and the build scripts easy to maintain.

Dependencies
------------

- Ruby >= 1.9
- Ruby Bundler
- Docker

Usage
-----

There are multiple ways to run the builders:

### Build packages on the current/local platform

Make sure `SENSU_VERSION` and `BUILD_NUMBER` are exported in the environment.

```
$ export SENSU_VERSION=0.20.6

$ export BUILD_NUMBER=1

$ bundle install

$ rake clean

$ rake
```

### Build packages on all supported platforms with Docker

```
$ export SENSU_VERSION=0.20.6

$ export BUILD_NUMBER=1

$ ./docker_build.sh
```

### Build packages on all supported platforms with Drone (CI using Docker)

```
$ ./build.sh
```

Acknowledgements
----------------

Big thanks to Adam Jacob for the suggestions on how to package Sensu and for
showing us the way with Omnibus!

Author
------

* [Joe Miller](https://twitter.com/miller_joe) - http://joemiller.me /  https://github.com/joemiller
* [Sean Porter](https://twitter.com/portertech) - https://about.me/seanporter / https://github.com/portertech

License
-------

    Author:: Joe Miller (<joeym@joeym.net>)
    Copyright:: Copyright (c) 2012 Joe Miller
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
