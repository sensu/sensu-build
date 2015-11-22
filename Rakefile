gem 'systemu', '2.6.5'
gem 'ohai', '6.18.0'
gem 'bunchr', '0.1.10'

require 'bunchr'
require 'fileutils'

if ENV['SENSU_VERSION'].nil?
  raise "Please set ENV['SENSU_VERSION'] and re-run."
end

if ENV['BUILD_NUMBER'].nil?
  raise "Please set ENV['BUILD_NUMBER'] and re-run."
end

Bunchr.load_recipes Dir['recipes/**/*.rake']

# Put together all the Software objects from the *.rake recipes and bunch
# them together into whatever packages this platform supports (tar, rpm, deb)!
Bunchr::Packages.new do |t|
  t.name = 'sensu'
  t.version = ENV['SENSU_VERSION']
  t.iteration = ENV['BUILD_NUMBER']

  t.category = 'Monitoring'
  t.license  = 'MIT License'
  t.vendor   = 'Heavy Water Operations, LLC.'
  t.url      = 'http://sensuapp.org'
  t.description = 'A monitoring framework that aims to be simple, malleable, and scalable.'
  t.maintainer = 'Sensu Helpdesk <helpdesk@sensuapp.com>'

  os              = t.ohai.os
  arch            = t.ohai.kernel["machine"]
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
      t.scripts[:after_remove]   = 'pkg_scripts/rpm/postun'
    end

    t.include_software('ruby')
    t.include_software('runit')
    t.include_software('sensu')
    t.include_software('sensu_plugin_1.2.0')
    t.include_software('sensu_plugin_1.4.0')
    t.include_software('sensu_configs')
    t.include_software('sensu_bin_stubs')

    etc_path = "/etc"
    bin_path = "/usr/bin"
    share_path = "/usr/share"
    log_path = "/var/log"

    if os == "freebsd"
      etc_path = "/usr/local/etc"
      share_path = "/usr/local/share"
    end

    t.files << Bunchr.install_dir
    t.files << "#{share_path}/sensu"
    t.files << "#{log_path}/sensu"
    t.files << "#{etc_path}/sensu/plugins"
    t.files << "#{etc_path}/sensu/mutators"
    t.files << "#{etc_path}/sensu/handlers"
    t.files << "#{etc_path}/sensu/extensions"

    # all linux platforms are currently using init.d
    # this may change in the future.
    if os == "linux"
      t.files << "#{etc_path}/init.d/sensu-service"
      t.files << "#{etc_path}/init.d/sensu-api"
      t.files << "#{etc_path}/init.d/sensu-client"
      t.files << "#{etc_path}/init.d/sensu-server"
      t.files << "#{bin_path}/sensu-install"
    end

    # need to enumerate config files for fpm
    # these are installed from recipe/sensu_configs.rake
    t.config_files << "#{etc_path}/sensu/config.json.example"
    t.config_files << "#{etc_path}/sensu/conf.d/README.md"

    if os == "linux"
      t.config_files << "#{etc_path}/logrotate.d/sensu"
      t.config_files << "#{etc_path}/default/sensu"
    end
  end
end

task :default => ['packages:sensu']
