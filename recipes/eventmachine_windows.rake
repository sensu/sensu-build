Bunchr::Software.new do |t|
  t.name = 'eventmachine_windows'
  t.version = '1.0.8'

  FileUtils.mkdir_p(t.work_dir)

  gem_bin = File.join(Bunchr.install_dir, 'embedded', 'bin', 'gem')

  install_prefix = "#{Bunchr.install_dir}\\embedded"

  t.install_commands << "#{gem_bin} install eventmachine -v #{t.version} --no-ri --no-rdoc -- --with-ssl-dir=#{install_prefix}"

  CLEAN << Bunchr.install_dir
end
