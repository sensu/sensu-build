require 'bunchr'

Bunchr.build_dir = '/tmp/build'
Bunchr.install_dir = '/opt/sensu'

Bunchr.load_recipes Dir['recipes/**/*.rake']


## determine the package version from the GIT_REF. Strip leading 'v'
if ENV['SENSU_GIT_REF'].nil?
  raise "Please set ENV['SENSU_GIT_REF'] and re-run."
end
sensu_package_version = ENV['SENSU_GIT_REF'].sub(/^v/,'')

## iteration will come from the jenkins $BUILD_NUMBER
if ENV['BUILD_NUMBER'].nil?
  raise "Please set ENV['BUILD_NUMBER'] and re-run."
end
sensu_package_iteration = ENV['BUILD_NUMBER']

# put together all the Software objects from the *.rake recipes and bunch
# them together into whatever packages this platform supports (tar, rpm, deb)!
Bunchr::Packages.new do |t|
  t.name = 'sensu'
  t.version = sensu_package_version
  t.iteration = sensu_package_iteration

  t.category = 'Monitoring'
  t.license  = 'MIT License'
  t.vendor   = 'Sonian Inc.'
  t.url      = 'https://github.com/sonian/sensu'
  t.description = 'A monitoring framework that aims to be simple, malleable, and scalable.'

  case t.ohai.platform_family
  when 'debian'
    t.scripts[:after_install]  = 'pkg_scripts/deb/postinst'
    t.scripts[:before_remove]  = 'pkg_scripts/deb/prerm'
    t.scripts[:after_remove]   = 'pkg_scripts/deb/postrm'
  when 'rhel', 'fedora'
    t.scripts[:before_install] = 'pkg_scripts/rpm/pre'
    t.scripts[:after_install]  = 'pkg_scripts/rpm/post'
    t.scripts[:before_remove]  = 'pkg_scripts/rpm/preun'
  end

  # we need these Bunchr::Software recipes built and installed
  t.include_software('runit')
  t.include_software('ruby')
  t.include_software('sensu')
  t.include_software('sensu_dashboard')
  t.include_software('sensu_configs')
  t.include_software('sensu_bin_stubs')

  t.files << Bunchr.install_dir # /opt/sensu
  t.files << '/usr/share/sensu'
  t.files << '/var/log/sensu'
  t.files << '/etc/sensu/plugins'
  t.files << '/etc/sensu/mutators'
  t.files << '/etc/sensu/handlers'

  # all platforms are currently using init.d. This may change in the future.
  t.files << '/etc/init.d/sensu-api'
  t.files << '/etc/init.d/sensu-client'
  t.files << '/etc/init.d/sensu-server'
  t.files << '/etc/init.d/sensu-dashboard'

  # need to enumerate config files for fpm
  # these are installed from recipe/sensu_configs.rake
  t.config_files << '/etc/sensu/config.json'
  t.config_files << '/etc/sensu/conf.d/README.md'
  t.config_files << '/etc/logrotate.d/sensu'

  # override (noop) the tarball tasks. we don't want them.
  def define_build_tarball; end
end

task :default => ['packages:sensu']
