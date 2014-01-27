Bunchr::Software.new do |t|
  t.name = 'assets'

  # build and install commands run from t.work_dir. In this case, our
  # files are located in the same dir as the Rakefile.
  t.work_dir = Dir.pwd
  install_prefix = "#{Bunchr.install_dir}/embedded"

  # Add certificates authority file from curl http://curl.haxx.se/ca/cacert.pem
  # openssl md5 assets/cacert.pem | grep -q '6253bb1b6696a190fdf7a2062003b21c'
  t.install_commands << "cp -f assets/cacert.pem #{install_prefix}/ssl/cert.pem"

end
