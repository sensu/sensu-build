Bunchr::Software.new do |t|
  t.name = 'ruby_windows_devkit'
  t.version = '4.7.2-20130224-1151'

  t.depends_on('ruby_windows')

  devkit_exe = "DevKit-mingw64-32-#{t.version}-sfx.exe"

  t.download_commands << "wget -P #{t.work_dir} http://rubyforge.org/frs/download.php/76805/#{devkit_exe}"

  install_prefix = "#{Bunchr.install_dir}\\embedded"

  t.build_commands << "#{devkit_exe} -y -o#{install_prefix}"
  t.build_commands << "echo - #{install_prefix} > #{install_prefix}\\config.yml"

  t.install_commands << "cd #{install_prefix} && #{install_prefix}\\bin\\ruby dk.rb install"

  CLEAN << install_prefix
end
