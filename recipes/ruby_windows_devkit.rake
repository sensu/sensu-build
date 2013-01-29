Bunchr::Software.new do |t|
  t.name = 'ruby_windows_devkit'
  t.version = '4.5.2-20111229-1559'

  t.depends_on('ruby_windows')

  install_prefix = File.join(Bunchr.install_dir, 'embedded')

  devkit_exe = "DevKit-tdm-32-#{t.version}-sfx.exe"

  t.download_commands << "curl -O http://cloud.github.com/downloads/oneclick/rubyinstaller/#{devkit_exe}"

  t.work_dir = t.download_dir

  t.build_commands << "#{devkit_exe} -y -o#{install_prefix}"
  t.build_commands << "echo - #{install_prefix} > #{install_prefix}\\config.yml"

  t.install_commands << "#{install_prefix}\\bin\\ruby #{install_prefix}\\dk.rb install"

  CLEAN << install_prefix
end
