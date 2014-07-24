sensu packages, build suite
===========================

This repo contains the toolset needed to build Sensu packages for all
currently supported platforms. The builds are 'omnibus' style packages
that contain everything they need to run, including their own build of Ruby
and all required gems.

The build suite relies heavily on Vagrant, Bunchr and FPM.

VM's are used to build packages native to each OS. E.g: .rpm's on CentOS, and
.deb's on Ubuntu. Bunchr allows the same scripts to be used on each platform
so builds are as consistent as possible and the build scripts easy to maintain.

The vagrant boxes used for building are generally default/vanilla boxes built
from Veewee templates and are available at:  http://vagrant.sensuapp.org

Dependencies
------------

- Oracle VirtualBox
- Vagrant
- Vagrant-Omnibus (https://github.com/schisamo/vagrant-omnibus)
- Ruby bundler
- GNU parallel(1)

Usage
-----

There are multiple ways to run the builders:

### Build packages on all supported platforms.

```
$ export SENSU_VERSION=v0.9.5   # any valid tag in the sensu.git repo. Will also
                                # be used as the 'version' in the .rpm/.deb's.
$ export BUILD_NUMBER=20        # could also use the jenkins build number
$ ./para-vagrant.sh
```

The `para-vagrant.sh` script will boot the VM's sequentially then run the
Vagrant provision process (build) in parallel on each VM.

VM's are booted sequentially to avoid any VirtualBox kernel panics.

The concurrency can be controlled by setting `$MAX_PROCS` at the top of the
`para-vagrant.sh` script.

Detailed Logs of each provision process will be generated in the `logs/`
directory.

### Build packages on a single platform, from outside the VM.

Make sure `SENSU_VERSION` and `BUILD_NUMBER` are exported in the environment.

```
$ vagrant up <BOX_NAME>
 ## or, if the box is already running:
$ vagrant provision <BOX_NAME>
```

You can always boot a box without running a build by executing:

```
$ vagrant up <BOX_NAME> --no-provision
```

### Build packages from within a VM (or build without Vagrant)

The builds can also be run without Vagrant, directly on a system (vm or
physical).

Make sure `SENSU_VERSION` and `BUILD_NUMBER` are exported in the environment.

```
$ ./build.sh
```

The build script will try to install some platform specific packages that
are typically not installed on minimal systems such as our Vagrant images.

Rake can also be called directly if you're sure the system has all of the
necessary OS packages installed:

```
$ rake
```

It's good to do a `rake clean` before building, but it's not necessary. Bunchr
will try to be smart and not re-run parts of the build process that have already
succeeded. Nonetheless, a clean should probably be done before an official
build.

Known Issues
-------------

* It's not uncommon to see VirtualBox kernel panic on Mac OSX:
  https://github.com/mitchellh/vagrant/issues/797

Acknowledgements
----------------

Big thanks to Adam Jacob for the suggestions on how to package Sensu and for
showing us the way with Omnibus!

Author
------

* [Joe Miller](https://twitter.com/miller_joe) - http://joemiller.me / https://github.com/joemiller

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
