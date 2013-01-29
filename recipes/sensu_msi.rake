require 'erb'

Bunchr::Software.new do |t|
  t.name = 'sensu_msi'

  t.version = ENV['SENSU_VERSION']

  build_iteration = ENV['BUILD_NUMBER']

  t.depends_on('ruby_windows_devkit')
  t.depends_on('sensu')

  FileUtils.mkdir_p(t.work_dir)

  assets = "#{Dir.pwd}\\sensu_configs\\msi"
  FileUtils.cp_r("#{assets}\\files\\.", t.work_dir)

  File.open("#{assets}\\templates\\Sensu-Config.wxi.erb") do |file|
    versions = t.version.split("-").first.split(".")
    @major_version = versions[0]
    @minor_version = versions[1]
    @micro_version = versions[2]
    @build_version = build_iteration

    @guid = '29B5AA66-46B3-4676-8D67-2F3FB31CC549'

    erb = ERB.new(file.read)
    File.open("#{t.work_dir}\\Sensu-Config.wxi", 'w') do |file|
      file.write(erb.result(binding))
    end
  end

  install_prefix = Bunchr.install_dir

  heat_cmd = "heat.exe dir \"#{install_prefix}\" -nologo -srd"
  heat_cmd << " -gg -cg SensuDir -dr SENSULOCATION -var var.SensuSourceDir -out Sensu-Files.wxs"
  t.build_commands << heat_cmd

  candle_cmd = "candle.exe -nologo -out ."
  candle_cmd << " -dSensuSourceDir=\"#{install_prefix}\" Sensu-Files.wxs Sensu.wxs"
  t.build_commands << candle_cmd

  light_cmd = "light.exe -nologo -ext WixUIExtension -cultures:en-us"
  light_cmd << " -loc Sensu-en-us.wxl Sensu-Files.wixobj Sensu.wixobj"
  light_cmd << " -out #{install_prefix}\\sensu-#{t.version}-#{build_iteration}.msi"

  CLEAN << install_prefix
end
