TODO
====


refactor & publish to github:
x	TODO: README
x	TODO: bring para-vagrant.sh in from sensu-tests
x	TODO: full test run of refactored directory/scripts
x	TODO: publish to github!



    TODO: should programatically get sensu version
    TODO: find a way to integrate this repo with the `sensu-tests` repo ?
	TODO: move box list out of the Vagrantfile into a json or yaml.
	TODO: add md5 validation of downloads to Bunchr
	TODO: gpg signing of .deb's in apt (can reprepro do it?)
x	TODO: allow Bunch::Software recipes to depend on others
x	TOOD: pkg_dir name.. work_dir ?
x	TODO: cleanup /opt/sensu/bin dir to only contain sensu-* bits
	TODO: include runit scripts in /usr/share/sensu/runit
	TODO: in postinstall scripts, announce that services are disabled by default (first install only)
x	TODO: create a gem out of Bunchr, upload to rubygems
x	TODO: refactor and rename directory after Bunchr is gemified
	TODO: DRY up Package class' build define_'s ?
	TODO: refactor Package class, don't rebuild a package if it already exists.. (??)
