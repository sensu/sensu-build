Bunchr::Software.new do |t|
  t.name = 'openssl_windows'
  t.version = '1.0.1p'

  windows_openssl_build = "openssl-#{t.version}-x86-windows"

  download_url = "https://github.com/jaym/windows-openssl-build/releases/download/openssl-#{t.version}/#{windows_openssl_build}.tar.lzma"

  t.download_commands << "wget --no-check-certificate -O #{windows_openssl_build}.tar.lzma #{download_url}"
  t.download_commands << "mkdir #{windows_openssl_build}"
  t.download_commands << "7z x #{windows_openssl_build}.tar.lzma -o#{windows_openssl_build}"

  t.work_dir = windows_openssl_build

  install_prefix = "#{Bunchr.install_dir}\\embedded"

  t.install_commands << "tar -xvf #{windows_openssl_build}.tar"
  t.install_commands << "xcopy . #{install_prefix}\\ /e /y"

  CLEAN << install_prefix
end
