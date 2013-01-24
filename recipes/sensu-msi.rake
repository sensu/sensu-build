Bunchr::Software.new do |t|
  t.name = 'sensu-msi'

  t.version = ENV['SENSU_VERSION']

  build_iteration = ENV['BUILD_NUMBER']

  t.depends_on('sensu')

  heat_cmd = "heat.exe dir \"#{Bunchr.install_dir}\" -nologo -srd"
  heat_cmd << " -gg -cg SensuDir -dr SENSULOCATION -var var.SensuSourceDir -out Sensu-Files.wxs"
  t.build_commands << heat_cmd

  msi_dir = File.join(Bunchr.install_dir, 'msi')

  assets = File.expand_path(File.join('..', File.dirname(__FILE__), 'assets', 'msi'))
  t.build_commands << "xcopy #{assets} msi /I /Y"

  candle_cmd = "candle.exe -nologo -out ."
  candle_cmd << " -dSensuSourceDir=\"#{Bunchr.install_dir}\" Sensu-Files.wxs Sensu.wxs"
  t.build_commands << candle_cmd

  light_cmd = "light.exe -nologo -ext WixUIExtension -cultures:en-us"
  light_cmd << " -loc Sensu-en-us.wxl Sensu-Files.wixobj Sensu.wixobj"
  light_cmd << " -out #{Bunchr.install_dir}\\sensu-#{t.version}-#{build_iteration}.msi"

  CLEAN << install_prefix
end
