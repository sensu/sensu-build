Bunchr::Software.new do |t|
  t.name = 'sensu_configs'

  os   = t.ohai['os']
  arch = t.ohai['kernel']['machine']

  # build and install commands run from t.work_dir. In this case, our
  # files are located in the same dir as the Rakefile.
  t.work_dir = Dir.pwd

  log_path = "/var/log"

  if os == "freebsd"
    etc_path = "/usr/local/etc"
    share_path = "/usr/local/share"

    t.install_commands << "rm -rf #{etc_path}/etc/rc.d/sensu-*"
    t.install_commands << "rm -rf #{etc_path}/default/sensu"
  else
    etc_path = "/etc"
    share_path = "/usr/share"

    t.install_commands << "rm -rf #{etc_path}/init.d/sensu-*"
    t.install_commands << "rm -rf #{etc_path}/default/sensu"
  end

  t.install_commands << "rm -rf #{etc_path}/sensu"
  t.install_commands << "rm -rf #{share_path}/sensu"
  t.install_commands << "rm -rf #{log_path}/sensu"

  t.install_commands << "cp -rf ./sensu_configs/sensu #{etc_path}/sensu"

  if os == "linux"
    t.install_commands << "cp -f ./sensu_configs/default/* #{etc_path}/default/"
    t.install_commands << "cp -f ./sensu_configs/logrotate.d/* #{etc_path}/logrotate.d/"
    t.install_commands << "cp -f ./sensu_configs/init.d/* #{etc_path}/init.d/"
  elsif os == "freebsd"
    t.install_commands << "mkdir -p #{etc_path}/default"
    t.install_commands << "mkdir -p /var/run/sensu"
    t.install_commands << "cp -f ./sensu_configs/default/* #{etc_path}/default/"
    t.install_commands << "cp -f ./sensu_configs/rc.d/* #{etc_path}/rc.d/"
  end

  t.install_commands << "mkdir -p #{share_path}/sensu"
  t.install_commands << "cp -rf ./sensu_configs/init.d #{share_path}/sensu/"
  t.install_commands << "cp -rf ./sensu_configs/upstart #{share_path}/sensu/"
  t.install_commands << "cp -rf ./sensu_configs/systemd #{share_path}/sensu/"
  t.install_commands << "cp -rf ./sensu_configs/rc.d #{share_path}/sensu/"

  t.install_commands << "mkdir -p #{log_path}/sensu"
  t.install_commands << "touch #{log_path}/sensu/.keep"

  %w[plugins mutators handlers extensions].each do |dir|
    t.install_commands << "mkdir -p #{etc_path}/sensu/#{dir}"
  end

  CLEAN << "#{log_path}/sensu"
  CLEAN << "#{etc_path}/sensu"
  CLEAN << "#{share_path}/sensu"
  CLEAN << "#{etc_path}/default/sensu"

  if os == "linux"
    CLEAN << "#{etc_path}/init.d/sensu-*"
  end
end
