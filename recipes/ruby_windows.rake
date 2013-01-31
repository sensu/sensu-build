Bunchr::Software.new do |t|
  t.name = 'ruby_windows'
  t.version = '1.9.3-p374'

  windows_ruby_build = "ruby-#{t.version}-i386-mingw32"

  t.download_commands << "wget http://rubyforge.org/frs/download.php/76707/#{windows_ruby_build}.7z"
  t.download_commands << "7z x #{windows_ruby_build}.7z"

  t.work_dir = windows_ruby_build

  install_prefix = "#{Bunchr.install_dir}\\embedded"

  t.install_commands << "xcopy . #{install_prefix}\\ /e /y"

  CLEAN << install_prefix
end
