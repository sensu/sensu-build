Bunchr::Software.new do |t|
  t.name = 'sensu_systemd'

  t.work_dir = Dir.pwd

  t.install_commands << "mkdir -p /usr/lib/systemd/system"
  t.install_commands << "cp -rf ./sensu_configs/systemd/* /usr/lib/systemd/system/"

  CLEAN << "/usr/lib/systemd/system/sensu-*"
end
