Bunchr::Software.new do |t|
  t.name = 'winsw'

  t.version = '1.16'

  install_prefix = Bunchr.install_dir

  t.download_commands << "wget --no-check-certificate https://github.com/kohsuke/winsw/archive/#{t.version}.zip"
  t.download_commands << "unzip #{t.version}"

  build_cmd = "C:\\windows\\Microsoft.NET\\Framework\\v4.0.30319\\MSBuild.exe winsw.sln"
  build_cmd << " /target:Clean;Build /p:Configuration=Release /p:PostBuildEvent="
  t.build_commands << build_cmd

  assets_dir = "#{Dir.pwd}\\assets\\msi"

  t.install_commands << "mkdir #{install_prefix}\\bin"
  t.install_commands << "copy bin\\Release\\winsw.exe #{install_prefix}\\bin\\sensu-client.exe"
  t.install_commands << "copy #{assets_dir}\\files\\sensu-client.exe.config #{install_prefix}\\bin\\sensu-client.exe.config"

  CLEAN << install_prefix
end
