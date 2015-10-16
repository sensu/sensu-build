Bunchr::Software.new do |t|
  t.name = 'sensu'

  if ENV['SENSU_VERSION'].nil?
    raise "Must set env var 'SENSU_VERSION'"
  end
  t.version = ENV['SENSU_VERSION']

  FileUtils.mkdir_p(t.work_dir)

  gem_bin = File.join(Bunchr.install_dir, 'embedded', 'bin', 'gem')

  if t.ohai['os'] == 'windows'
    ssl_dir = "#{Bunchr.install_dir}\\embedded"
  else
    ssl_dir = File.join(Bunchr.install_dir, 'embedded')
  end

  t.install_commands << "#{gem_bin} install sensu -v #{t.version} --no-ri --no-rdoc -- --with-ssl-dir=#{ssl_dir}"

  CLEAN << Bunchr.install_dir
end
