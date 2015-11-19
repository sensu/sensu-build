Bunchr::Software.new do |t|
  t.name = 'ruby'
  t.version = '2.3.0'

  t.depends_on('autoconf')
  t.depends_on('zlib')
  t.depends_on('openssl')
  t.depends_on('libyaml')

  install_prefix = "#{Bunchr.install_dir}/embedded"

  os   = t.ohai['os']
  arch = t.ohai['kernel']['machine']

  t.download_commands << "curl -O http://ftp.ruby-lang.org/pub/ruby/2.3/ruby-#{t.version}.tar.gz"
  t.download_commands << "tar xfvz ruby-#{t.version}.tar.gz"

  #%w(RUBYOPT BUNDLE_BIN_PATH BUNDLE_GEMFILE GEM_PATH GEM_HOME).each do |env_var|
  #  t.build_environment[env_var] = nil
  #end

  #t.install_environment['RUBYOPT'] = "-rbundler/setup"
  #t.install_environment['BUNDLE_BIN_PATH'] = "/home/freebsd/.rvm/gems/ruby-2.2.3/gems/bundler-1.10.6/bin/bundle"
  #t.install_environment['BUNDLE_GEMFILE'] = "/usr/home/freebsd/sensu-build/Gemfile"
  #t.install_environment['GEM_PATH'] = "/home/freebsd/.rvm/gems/ruby-2.2.3:/home/freebsd/.rvm/gems/ruby-2.2.3@global"
  #t.install_environment['GEM_HOME'] = "/home/freebsd/.rvm/gems/ruby-2.2.3"
  
  if os == 'darwin' && arch == 'x86_64'
    t.build_environment['LDFLAGS'] = "-arch x86_64 -R#{install_prefix}/lib -L#{install_prefix}/lib -I#{install_prefix}/include"
    t.build_environment['CFLAGS'] = "-arch x86_64 -m64 -L#{install_prefix}/lib -I#{install_prefix}/include"
  elsif os == 'linux'
    t.build_environment['LDFLAGS'] = "-Wl,-rpath #{install_prefix}/lib -L#{install_prefix}/lib -I#{install_prefix}/include"
    t.build_environment['CFLAGS'] = "-L#{install_prefix}/lib -I#{install_prefix}/include"
  elsif os == 'solaris2'
    t.build_environment['LDFLAGS'] = "-R#{install_prefix}/lib -L#{install_prefix}/lib -I#{install_prefix}/include"
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
