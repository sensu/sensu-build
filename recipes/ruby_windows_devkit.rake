Bunchr::Software.new do |t|
  t.name = 'ruby_windows_devkit'
  t.version = '4.5.2-20111229-1559'

  t.depends_on('ruby_windows')

  devkit_exe = "DevKit-tdm-32-#{t.version}-sfx.exe"

  t.download_commands << "wget -P #{t.work_dir} http://cloud.github.com/downloads/oneclick/rubyinstaller/#{devkit_exe}"

  install_prefix = "#{Bunchr.install_dir}\\embedded"

  t.build_commands << "#{devkit_exe} -y -o#{install_prefix}"
  t.build_commands << "echo - #{install_prefix} > #{install_prefix}\\config.yml"

  t.install_commands << "cd #{install_prefix} && #{install_prefix}\\bin\\ruby dk.rb install"

  CLEAN << install_prefix
end
