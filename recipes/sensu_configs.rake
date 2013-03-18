Bunchr::Software.new do |t|
  t.name = 'sensu_configs'

  # build and install commands run from t.work_dir. In this case, our
  # files are located in the same dir as the Rakefile.
  t.work_dir = Dir.pwd

  t.install_commands << "rm -rf /etc/sensu"
  t.install_commands << "rm -rf /etc/default/sensu"
  t.install_commands << "rm -rf /etc/init.d/sensu-*"
  t.install_commands << "rm -rf /usr/share/sensu"
  t.install_commands << "rm -rf /var/log/sensu"

  t.install_commands << "cp -rf ./sensu_configs/sensu /etc/sensu"

  t.install_commands << "cp -f ./sensu_configs/default/sensu /etc/default/sensu"

  t.install_commands << "cp -f ./sensu_configs/logrotate.d/sensu /etc/logrotate.d/sensu"

  t.install_commands << "cp -f ./sensu_configs/init.d/* /etc/init.d/"

  t.install_commands << "cp -rf ./sensu_configs/init.d /usr/share/sensu/"
  t.install_commands << "cp -rf ./sensu_configs/upstart /usr/share/sensu/"
  t.install_commands << "cp -rf ./sensu_configs/systemd /usr/share/sensu/"

  t.install_commands << "mkdir /var/log/sensu"

  %w[plugins mutators handlers extensions].each do |dir|
    t.install_commands << "mkdir /etc/sensu/#{dir}"
  end

  CLEAN << "/var/log/sensu"
  CLEAN << "/etc/sensu"
  CLEAN << "/etc/default/sensu"
  CLEAN << "/etc/init.d/sensu-*"
  CLEAN << "/usr/share/sensu"
end
