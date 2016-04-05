Bunchr::Software.new do |t|
  t.name = 'sensu'

  if ENV['SENSU_VERSION'].nil?
    raise "Must set env var 'SENSU_VERSION'"
  end
  t.version = ENV['SENSU_VERSION']

  FileUtils.mkdir_p(t.work_dir)

  gem_bin = File.join(Bunchr.install_dir, 'embedded', 'bin', 'gem')

  compile_options = ''

  if t.ohai['os'] == 'windows'
    install_prefix = "#{Bunchr.install_dir}\\embedded"

    compile_options << " --with-ssl-dir=#{install_prefix}\\bin"
    compile_options << " --with-ssl-lib=#{install_prefix}\\lib"
    compile_options << " --with-ssl-include=#{install_prefix}\\include"
    compile_options << " --with-opt-include=#{install_prefix}\\include"
  else
    t.install_commands << "#{gem_bin} update --system"
  end

  t.install_commands << "#{gem_bin} install sensu -v #{t.version} --platform=ruby --no-ri --no-rdoc -- #{compile_options}"

  CLEAN << Bunchr.install_dir
end
