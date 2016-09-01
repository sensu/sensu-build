Bunchr::Software.new do |t|
  t.name = 'ruby'
  t.version = '2.3.0'

  os   = t.ohai['os']
  arch = t.ohai['kernel']['machine']

  t.depends_on('libgmp') if os == "freebsd"
  t.depends_on('libffi') if os == "freebsd"
  t.depends_on('libstdc++') if os == "freebsd"
  t.depends_on('autoconf')
  t.depends_on('zlib')
  t.depends_on('openssl')
  t.depends_on('libyaml')

  install_prefix = "#{Bunchr.install_dir}/embedded"

  os   = t.ohai['os']
  arch = t.ohai['kernel']['machine']

  t.download_commands << "curl -O http://ftp.ruby-lang.org/pub/ruby/2.3/ruby-#{t.version}.tar.gz"
  t.download_commands << "tar xfvz ruby-#{t.version}.tar.gz"

  if os == 'darwin' && arch == 'x86_64'
    t.build_environment['LDFLAGS'] = "-arch x86_64 -R#{install_prefix}/lib -L#{install_prefix}/lib -I#{install_prefix}/include"
    t.build_environment['CFLAGS'] = "-arch x86_64 -m64 -L#{install_prefix}/lib -I#{install_prefix}/include"
  elsif os == 'linux'
    t.build_environment['LDFLAGS'] = "-Wl,-rpath #{install_prefix}/lib -L#{install_prefix}/lib -I#{install_prefix}/include"
    t.build_environment['CFLAGS'] = "-L#{install_prefix}/lib -I#{install_prefix}/include"
  elsif os == 'solaris2'
    t.build_environment['LDFLAGS'] = "-R#{install_prefix}/lib -L#{install_prefix}/lib -I#{install_prefix}/include"
    t.build_environment['CFLAGS'] = "-L#{install_prefix}/lib -I#{install_prefix}/include"
  elsif os == 'freebsd'
    t.build_environment['LDFLAGS'] = "-Wl,-rpath #{install_prefix}/lib -L#{install_prefix}/lib -I#{install_prefix}/include"
    t.build_environment['CFLAGS'] = "-L#{install_prefix}/lib -I#{install_prefix}/include"
  end

  if arch == "armv6l" || arch == "armv7l"
    t.build_environment['CFLAGS'] = "-march=armv6 -mfloat-abi=hard -mfpu=vfp #{t.build_environment['CFLAGS']}"
  end

  t.build_commands << "./configure --prefix=#{install_prefix} \
                      --with-opt-dir=#{install_prefix} \
                      --enable-shared \
                      --disable-install-doc"
  t.build_commands << "make"

  t.install_commands << "make install"

  CLEAN << install_prefix
end
