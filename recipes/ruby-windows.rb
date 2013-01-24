Bunchr::Software.new do |t|
  t.name = 'ruby-windows'
  t.version = '1.9.3-p374'

  install_prefix = File.join(Bunchr.install_dir, 'embedded')

  windows_ruby_build = "ruby-#{t.version}-i386-mingw32"

  t.download_commands << "curl -O http://rubyforge.org/frs/download.php/76707/#{windows_ruby_build}.7z"
  t.download_commands << "7z.exe x #{windows_ruby_build}.7z"

  t.work_dir = windows_ruby_build

  t.install_commands << "robocopy . #{install_prefix}\\ /MIR"

  CLEAN << install_prefix
end
