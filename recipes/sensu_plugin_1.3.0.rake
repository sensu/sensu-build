Bunchr::Software.new do |t|
  version = "1.3.0"

  t.name = "sensu_plugin_#{version}"
  t.version = version

  FileUtils.mkdir_p(t.work_dir)

  gem_bin = File.join(Bunchr.install_dir, 'embedded', 'bin', 'gem')

  t.install_commands << "#{gem_bin} install sensu-plugin -v #{t.version} --no-ri --no-rdoc"
end
