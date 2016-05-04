Bunchr::Software.new do |t|
  t.name = 'autoconf'
  t.version = '2.63'

  install_prefix = "#{Bunchr.install_dir}/embedded"

  t.download_commands << "curl -O http://ftp.gnu.org/gnu/autoconf/autoconf-2.63.tar.gz"
  t.download_commands << "tar xfvz autoconf-2.63.tar.gz"

  t.build_environment['LDFLAGS'] = "-R#{install_prefix}/lib -L#{install_prefix}/lib -I#{install_prefix}/include"
  t.build_environment['CFLAGS']  = "-L#{install_prefix}/lib -I#{install_prefix}/include"

  arch = t.ohai['kernel']['machine']

  if arch == "armv6l" || arch == "armv7l"
    t.build_environment['CFLAGS'] = "-march=armv6 -mfloat-abi=hard -mfpu=vfp #{t.build_environment['CFLAGS']}"
  end

  t.build_commands << "./configure --prefix=#{install_prefix}"
  t.build_commands << "make"

  t.install_commands << "make install"

  CLEAN << install_prefix
end
