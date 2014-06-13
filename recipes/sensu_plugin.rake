Bunchr::Software.new do |t|
  t.name = 'sensu_plugin'

  t.version = '0.3.0'

  install_prefix = "#{Bunchr.install_dir}"

  gem_bin = File.join(Bunchr.install_dir, 'embedded', 'bin', 'gem')

  t.install_commands << "#{gem_bin} install sensu-plugin -v #{t.version} --no-ri --no-rdoc"
end
