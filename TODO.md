## TODO

* programatically get sensu version
  * remove SENSU_VERSION from environment
  * use Sensu::VERSION
* find a way to integrate this repo with the `sensu-tests` repo ?
* move box list out of the Vagrantfile into a json or yaml.
* add md5 validation of downloads to Bunchr
* gpg signing of .deb's in apt (can reprepro do it?)
* include runit scripts in /usr/share/sensu/runit
* in postinstall scripts, announce that services are disabled by default (first install only)
* DRY up Package class' build define_'s ?
* refactor Package class, don't rebuild a package if it already exists.. (??)

### Support building by git tags

* add support for selecting git ref
* pull ref from the environment (SENSU_GIT_REF), use in:
  * sensu.rake recipe
  * Vagrantfile
  * build.sh
