gem 'systemu', '2.2.0'
gem 'ohai', '6.18.0'
gem 'bunchr', '0.1.6'

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

  platform_family = t.ohai.platform_family

  init_strategy = \
    if platform_family == 'rhel' && ( t.iteration.match(/el7$/) )
      'systemd'
    else
      'init.d'
    end

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
      case init_strategy
      when 'init.d'
        t.scripts[:after_install]  = 'pkg_scripts/rpm/post_init'
        t.scripts[:before_remove]  = 'pkg_scripts/rpm/preun_init'
        t.scripts[:after_remove]   = 'pkg_scripts/rpm/postun_init'
      when 'systemd'
        t.scripts[:after_install]  = 'pkg_scripts/rpm/post_systemd'
        t.scripts[:before_remove]  = 'pkg_scripts/rpm/preun_systemd'
        t.scripts[:after_remove]   = 'pkg_scripts/rpm/postun_systemd'
      end
    end

    t.include_software('ruby')
    t.include_software('runit')
    t.include_software('sensu')
    t.include_software('sensu_plugin')
    t.include_software('sensu_configs')
    t.include_software('sensu_bin_stubs')

    t.files << Bunchr.install_dir
    t.files << '/usr/share/sensu'
    t.files << '/usr/bin/sensu-install'
    t.files << '/var/log/sensu'
    t.files << '/etc/sensu/plugins'
    t.files << '/etc/sensu/mutators'
    t.files << '/etc/sensu/handlers'
    t.files << '/etc/sensu/extensions'

    case init_strategy
    when 'init.d'
      t.include_software('sensu_init')
      t.files << '/etc/init.d/sensu-service'
      t.files << '/etc/init.d/sensu-api'
      t.files << '/etc/init.d/sensu-client'
      t.files << '/etc/init.d/sensu-server'
    when 'systemd'
      t.include_software('sensu_systemd')
      t.files << '/usr/lib/systemd/system/sensu-api.service'
      t.files << '/usr/lib/systemd/system/sensu-client.service'
      t.files << '/usr/lib/systemd/system/sensu-server.service'
      t.files << '/usr/lib/systemd/system/sensu-runsvdir.service'
    end

    # need to enumerate config files for fpm
    # these are installed from recipe/sensu_configs.rake
    t.config_files << '/etc/sensu/config.json.example'
    t.config_files << '/etc/sensu/conf.d/README.md'
    t.config_files << '/etc/logrotate.d/sensu'
    t.config_files << '/etc/default/sensu'
  end
end

task :default => ['packages:sensu']
