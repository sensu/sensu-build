Bunchr::Software.new do |t|
  t.name = 'sensu_plugin'

  install_prefix = "#{Bunchr.install_dir}"
  # use the gem installed by the ruby.rake recipe in <Bunchr.install_dir>/embedded/bin
  gem_bin = "#{install_prefix}/embedded/bin/gem"

  t.download_commands << "git clone git://github.com/sensu/sensu-plugin.git"

  t.work_dir = 'sensu-plugin'
  
  t.build_commands << "rm -f sensu-plugin-*.gem"
  t.build_commands << "#{gem_bin} build sensu-plugin.gemspec"

  t.install_commands << "#{gem_bin} install --no-ri --no-rdoc \
                        sensu-plugin-*.gem"
end
