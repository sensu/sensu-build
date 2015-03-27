require 'erb'

Bunchr::Software.new do |t|
  t.name = 'runit'
  t.version = '2.1.1'
  md5 = "8fa53ea8f71d88da9503f62793336bc3"

  install_path = Bunchr.install_dir
  service_path = File.join(install_path, 'service')
  sv_path = File.join(install_path, 'sv')
  install_prefix = File.join(install_path, "embedded")
  gem_bin = File.join(install_prefix, 'bin', 'gem')
  scripts_dir = File.join(Dir.pwd,'runit_scripts')

  os   = t.ohai['os']
  arch = t.ohai['kernel']['machine']

  if os == "freebsd"
    md5_command = "md5 -r"
  else
    md5_command = "md5sum"
  end

  t.download_commands << "curl -O http://smarden.org/runit/runit-#{t.version}.tar.gz"
  t.download_commands << "test \"$(#{md5_command} runit-#{t.version}.tar.gz|awk '{print $1}')\" = #{md5}"
  t.download_commands << "tar zxvf runit-#{t.version}.tar.gz"

  t.work_dir = "admin/runit-#{t.version}/src"
  t.build_commands << 'sed -i -e "s|^char\ \*varservice\ \=\"/service/\";$|char\ \*varservice\ \=\"' + service_path + '/\";|" sv.c'
  t.build_commands << 'sed -i -e s:-static:: Makefile'
  t.build_commands << "make"
  t.build_commands << "make check" unless arch == "armv6l" || arch == "armv7l" # TODO: figure out why this doesn't work on ARM

  t.install_commands << "mkdir -p #{install_prefix}/bin"
  t.install_commands << "mkdir -p #{service_path}"

  ["chpst",
   "runsv",
   "runsvdir",
   "sv",
   "svlogd",
   "utmpset"].each do |bin|
    t.install_commands << "cp #{bin} #{install_prefix}/bin"
  end

  t.install_commands << "cp -f #{scripts_dir}/sensu-runsvdir.sh #{install_prefix}/bin/sensu-runsvdir"
  t.install_commands << "chmod 755 #{install_prefix}/bin/sensu-runsvdir"

  # need ohai and systemu for sensu-ctl
  t.install_commands << "#{gem_bin} install ohai -v 6.16.0 --no-ri --no-rdoc"
  t.install_commands << "#{gem_bin} install systemu -v 2.5.2 --no-ri --no-rdoc"

  t.install_commands << "cp -f #{scripts_dir}/sensu-ctl.rb #{install_prefix}/bin/sensu-ctl"
  t.install_commands << "chmod 0755 #{install_prefix}/bin/sensu-ctl"

  unless t.ohai['os'] == 'windows'
    ["client","server","api","dashboard"].each do |sv|
      FileUtils.mkdir_p("#{sv_path}/sensu-#{sv}/supervise")
      File.open("#{scripts_dir}/sensu-sv-run.sh.erb") do |template|
        @sv = sv
        erb = ERB.new(template.read)
        File.open("#{sv_path}/sensu-#{sv}/run", 'w') do |file|
          file.write(erb.result(binding))
        end
      end
      t.install_commands << "mkdir -p #{sv_path}/sensu-#{sv}/log/main"
      t.install_commands << "cp -f #{scripts_dir}/sensu-sv-log.sh #{sv_path}/sensu-#{sv}/log/run"
      t.install_commands << "chmod 0755 #{sv_path}/sensu-#{sv}/run #{sv_path}/sensu-#{sv}/log/run"
    end
  end

  CLEAN << install_prefix
end
