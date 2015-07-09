Bunchr::Software.new do |t|
  t.name = 'sensu_plugin'

  t.version = '1.2.0'

  FileUtils.mkdir_p(t.work_dir)

  gem_bin = File.join(Bunchr.install_dir, 'embedded', 'bin', 'gem')

  t.install_commands << "#{gem_bin} install sensu-plugin -v #{t.version} --no-ri --no-rdoc"
end
