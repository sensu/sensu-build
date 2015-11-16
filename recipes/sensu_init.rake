Bunchr::Software.new do |t|
  t.name = 'sensu_init'

  t.work_dir = Dir.pwd

  t.install_commands << "cp -f ./sensu_configs/init.d/* /etc/init.d/"

  CLEAN << "/etc/init.d/sensu-*"
end
