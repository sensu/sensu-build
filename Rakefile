require 'bunchr'
require 'fileutils'

if ENV['SENSU_VERSION'].nil?
  raise "Please set ENV['SENSU_VERSION'] and re-run."
end

## iteration will come from the jenkins $BUILD_NUMBER
if ENV['BUILD_NUMBER'].nil?
  raise "Please set ENV['BUILD_NUMBER'] and re-run."
end

Bunchr.load_recipes Dir['recipes/**/*.rake']

# put together all the Software objects from the *.rake recipes and bunch
# them together into whatever packages this platform supports (tar, rpm, deb)!
Bunchr::Packages.new do |t|
  t.name = 'sensu'
  t.version = ENV['SENSU_VERSION']
  t.iteration = ENV['BUILD_NUMBER']

  t.category = 'Monitoring'
  t.license  = 'MIT License'
  t.vendor   = 'Sonian Inc.'
  t.url      = 'https://github.com/sonian/sensu'
  t.description = 'A monitoring framework that aims to be simple, malleable, and scalable.'

  platform_family = t.ohai.platform_family

  case platform_family
  when 'windows'
    Bunchr.build_dir = 'C:\build'
    Bunchr.install_dir = 'C:\opt\sensu'

    t.include_software('sensu_msi')
  else
    Bunchr.build_dir = '/tmp/build'
    Bunchr.install_dir = '/opt/sensu'

    case platform_family
    when 'debian'
      t.scripts[:after_install]  = 'pkg_scripts/deb/postinst'
      t.scripts[:before_remove]  = 'pkg_scripts/deb/prerm'
      t.scripts[:after_remove]   = 'pkg_scripts/deb/postrm'
    when 'rhel', 'fedora', 'suse'
      t.scripts[:before_install] = 'pkg_scripts/rpm/pre'
      t.scripts[:after_install]  = 'pkg_scripts/rpm/post'
      t.scripts[:before_remove]  = 'pkg_scripts/rpm/preun'
    end

    t.include_software('ruby')
    t.include_software('sensu')
    t.include_software('sensu_dashboard')
    t.include_software('sensu_plugin')
    t.include_software('sensu_configs')
    t.include_software('sensu_bin_stubs')

    t.files << Bunchr.install_dir
    t.files << '/usr/share/sensu'
    t.files << '/var/log/sensu'
    t.files << '/etc/sensu/plugins'
    t.files << '/etc/sensu/mutators'
    t.files << '/etc/sensu/handlers'

    t.files << '/etc/default/sensu'

    # all linux platforms are currently using init.d
    # this may change in the future.
    t.files << '/etc/init.d/sensu-service'
    t.files << '/etc/init.d/sensu-api'
    t.files << '/etc/init.d/sensu-client'
    t.files << '/etc/init.d/sensu-server'
    t.files << '/etc/init.d/sensu-dashboard'

    # need to enumerate config files for fpm
    # these are installed from recipe/sensu_configs.rake
    t.config_files << '/etc/sensu/config.json'
    t.config_files << '/etc/sensu/conf.d/README.md'
    t.config_files << '/etc/logrotate.d/sensu'
  end
end

task :default => ['packages:sensu']
