Bunchr::Software.new do |t|
  os = t.ohai["os"]

  if os == "freebsd"
    t.name = "libstdc++"
    t.version = "4.9.4"
    t.work_dir = "."

    install_prefix = "#{Bunchr.install_dir}/embedded"

    t.install_commands << "cp /usr/local/lib/gcc49/libstdc++.so.6 #{install_prefix}/lib"

    CLEAN << install_prefix
  end
end
