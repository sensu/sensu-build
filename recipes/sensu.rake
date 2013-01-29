Bunchr::Software.new do |t|
  t.name = 'sensu'

  if ENV['SENSU_VERSION'].nil?
    raise "Must set env var 'SENSU_VERSION'"
  end
  t.version = ENV['SENSU_VERSION']

  FileUtils.mkdir_p(t.work_dir)

  gem_bin = File.join(Bunchr.install_dir, 'embedded', 'bin', 'gem')

  t.install_commands << "#{gem_bin} install sensu -v #{t.version} --no-ri --no-rdoc"

  CLEAN << Bunchr.install_dir
end
