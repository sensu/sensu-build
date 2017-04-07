Bunchr::Software.new do |t|
  os = t.ohai["os"]

  if os == "freebsd"
    t.name = "libffi"
    t.version = "1.9.10"
    t.work_dir = "/usr/ports/devel/libffi"

    install_prefix = "#{Bunchr.install_dir}/embedded"

    t.build_environment["PREFIX"] = install_prefix
    t.build_environment["BATCH"] = "yes"

    t.build_commands << "make"

    t.install_environment["PREFIX"] = install_prefix
    t.install_environment["BATCH"] = "yes"

    t.install_commands << "make deinstall"
    t.install_commands << "make install clean"

    CLEAN << install_prefix
  end
end
