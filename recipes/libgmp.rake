Bunchr::Software.new do |t|
  os = t.ohai["os"]

  if os == "freebsd"
    t.name = "libgmp"
    t.version = "5.1.3_2"
    t.work_dir = "/usr/ports/math/gmp"

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
