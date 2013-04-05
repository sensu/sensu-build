Bunchr::Software.new do |t|
  t.name = 'winsw'

  t.version = '1.12'

  install_prefix = Bunchr.install_dir

  t.download_commands << "wget https://github.com/kohsuke/winsw/archive/#{t.version}.zip"
  t.download_commands << "unzip winsw-#{t.version}.zip"

  build_cmd = "C:\\windows\\Microsoft.NET\\Framework\\v4.0.30319\\MSBuild.exe winsw.sln"
  build_cmd << " /target:Clean;Build /p:Configuration=Release /p:PostBuildEvent="
  t.build_commands << build_cmd

  t.install_commands << "mkdir #{install_prefix}\\bin"
  t.install_commands << "copy bin\\Release\\winsw.exe #{install_prefix}\\bin\\sensu-client.exe"

  CLEAN << install_prefix
end
