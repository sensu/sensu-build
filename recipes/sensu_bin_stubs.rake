Bunchr::Software.new do |t|
  t.name = 'sensu_bin_stubs'

  bin_dir = "#{Bunchr.install_dir}/bin"
  os = t.ohai.os

  sensu_install_cmd = "sensu-install"
  system_bin_path = "/usr/bin"
  
  if os == "freebsd"
    sensu_install_cmd = "#{sensu_install_cmd}-freebsd"
    system_bin_path = "/usr/local/bin"
  end

  # build and install commands run from t.work_dir. In this case, our
  # files are located in the same dir as the Rakefile.
  t.work_dir = Dir.pwd

  t.install_commands << "rm -rf #{bin_dir}"
  t.install_commands << "mkdir -p #{bin_dir}"

  t.install_commands << "ln -s ../embedded/bin/sensu-api    #{bin_dir}/sensu-api"
  t.install_commands << "ln -s ../embedded/bin/sensu-client #{bin_dir}/sensu-client"
  t.install_commands << "ln -s ../embedded/bin/sensu-server #{bin_dir}/sensu-server"
  t.install_commands << "ln -s ../embedded/bin/sensu-ctl #{bin_dir}/sensu-ctl"

  t.install_commands << "cp sensu_configs/bin/#{sensu_install_cmd} #{bin_dir}/sensu-install"
  t.install_commands << "cp sensu_configs/bin/#{sensu_install_cmd} #{system_bin_path}/sensu-install"
end
