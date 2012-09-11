Bunchr::Software.new do |t|
  t.name = 'runit'
  t.version = '2.1.1'
  md5 = "8fa53ea8f71d88da9503f62793336bc3"

  install_path = Bunchr.install_dir
  service_path = File.join(install_path, "service")
  install_prefix = File.join(install_path, "embedded")

  t.download_commands << "curl -O http://smarden.org/runit/runit-#{t.version}.tar.gz"
  t.download_commands << "test \"$(md5sum runit-#{t.version}.tar.gz|awk '{print $1}')\" == #{md5}"
  t.download_commands << "tar zxvf runit-#{t.version}.tar.gz"

  os   = t.ohai['os']
  arch = t.ohai['kernel']['machine']

  t.work_dir = "admin/runit-#{t.version}/src"
  t.build_commands << 'sed -i -e "s|^char\ \*varservice\ \=\"/service/\";$|char\ \*varservice\ \=\"' + service_path + '/\";|" sv.c'
  t.build_commands << "make"
  t.build_commands << "make check"

  t.install_commands << "mkdir -p #{install_prefix}/bin"
  t.install_commands << "mkdir -p #{service_path}"
  t.install_commands << "mkdir -p #{install_path}/sv"
  ["chpst",
   "runsv",
   "runsvdir",
   "sv",
   "svlogd",
   "utmpset"].each do |bin|
    t.install_commands << "cp #{bin} #{install_prefix}/bin"
  end
  t.install_commands << "echo -e \"/bin/sh -e\nPATH=#{install_path}/bin:#{install_prefix}/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin\nexec chpst -e - PATH=$PATH runsvdir -P #{service_path} 'log: .................................................................................................................................'\" > #{install_prefix}/bin/runsvdir-start"
  t.install_commands << "chmod 755 #{install_prefix}/bin/runsvdir-start"

  CLEAN << install_prefix
end
