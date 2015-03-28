Bunchr::Software.new do |t|
  t.name = 'sensu_configs'

  os   = t.ohai['os']
  arch = t.ohai['kernel']['machine']

  # build and install commands run from t.work_dir. In this case, our
  # files are located in the same dir as the Rakefile.
  t.work_dir = Dir.pwd

  etc_path = "/etc"
  share_path = "/usr/share"
  log_path = "/var/log"

  if os == "freebsd"
    etc_path = "/usr/local/etc"
    share_path = "/usr/local/share"
  else
    t.install_commands << "rm -rf #{etc_path}/default/sensu"
    t.install_commands << "rm -rf #{etc_path}/init.d/sensu-*"
  end

  t.install_commands << "rm -rf #{etc_path}/sensu"
  t.install_commands << "rm -rf #{share_path}/sensu"
  t.install_commands << "rm -rf #{log_path}/sensu"

  t.install_commands << "cp -rf ./sensu_configs/sensu #{etc_path}/sensu"

  if os == "linux"
    t.install_commands << "cp -f ./sensu_configs/default/* #{etc_path}/default/"
    t.install_commands << "cp -f ./sensu_configs/logrotate.d/* #{etc_path}/logrotate.d/"
    t.install_commands << "cp -f ./sensu_configs/init.d/* #{etc_path}/init.d/"
  end

  t.install_commands << "mkdir #{share_path}/sensu"
  t.install_commands << "cp -rf ./sensu_configs/init.d #{share_path}/sensu/"
  t.install_commands << "cp -rf ./sensu_configs/upstart #{share_path}/sensu/"
  t.install_commands << "cp -rf ./sensu_configs/systemd #{share_path}/sensu/"

  t.install_commands << "mkdir #{log_path}/sensu"

  %w[plugins mutators handlers extensions].each do |dir|
    t.install_commands << "mkdir #{etc_path}/sensu/#{dir}"
  end

  CLEAN << "#{log_path}/sensu"
  CLEAN << "#{etc_path}/sensu"
  CLEAN << "#{share_path}/sensu"

  if os != "freebsd"
    CLEAN << "#{etc_path}/default/sensu"
    CLEAN << "#{etc_path}/init.d/sensu-*"
  end
end
