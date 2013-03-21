#!/opt/sensu/embedded/bin/ruby
#
# Authors:: Adam Jacob (<adam@opscode.com>), Sean Porter (<portertech@gmail.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "ohai"
require "systemu"

def get_all_services_files
  Dir["/opt/sensu/sv/*"]
end

def get_all_services
  get_all_services_files.map { |f| File.basename(f) }
end

def service_enabled?(service_name)
  File.symlink?("/opt/sensu/service/#{service_name}")
end

def enable_service(service_name)
  unless service_enabled?(service_name)
    File.symlink("/opt/sensu/sv/#{service_name}", "/opt/sensu/service/#{service_name}")
  end
end

def disable_service(service_name)
  if service_enabled?(service_name)
    File.delete("/opt/sensu/service/#{service_name}")
  end
end

def sv_command_list
  %w[status up down once pause cont hup alarm interrupt quit 1 2 term kill start stop restart shutdown force-stop force-reload force-restart force-shutdown check]
end

def run_sv_command(sv_cmd, service=nil)
  exit_status = 0
  get_all_services.each do |service_name|
    next if !service.nil? && service_name != service
    if service_enabled?(service_name)
      status, stdout, stderr = systemu("/opt/sensu/embedded/bin/sv #{sv_cmd} #{service_name}")
      puts stdout
      exit_status = status.exitstatus if exit_status == 0 && !status.success?
    else
      puts "#{service_name} disabled" if sv_cmd == "status"
    end
  end
  exit exit_status
end

def service_list
  get_all_services.each do |service_name|
    print "#{service_name}"
    print "*" if service_enabled?(service_name)
    print "\n"
  end
  exit 0
end

def run_command(cmd, retries=1, output=true)
  while retries > 0 do
    status, stdout, stderr = systemu(cmd)
    if output
      puts stdout unless stdout.empty?
      puts stderr unless stderr.empty?
    end
    return true if status.exitstatus == 0
    sleep 1
    retries -= 1
  end
  false
end

def setup_failed(msg)
  puts msg
  exit 2
end

def setup_runsvdir_upstart
  if run_command("cp /usr/share/sensu/upstart/sensu-runsvdir.conf /etc/init/")
    if run_command("initctl status sensu-runsvdir", 10)
      if run_command("initctl status sensu-runsvdir | grep stop")
        run_command("initctl start sensu-runsvdir", 10)
      end
    else
      setup_failed("failed to find sensu-runsvdir job")
    end
  else
    setup_failed("failed to create /etc/init/sensu-runsvdir.conf")
  end
end

def setup_runsvdir_sysvinit
  sv_dir_line = "SR:123456:respawn:/opt/sensu/embedded/bin/sensu-runsvdir"
  unless run_command("grep '#{sv_dir_line}' /etc/inittab")
    if run_command("echo '#{sv_dir_line}' >> /etc/inittab")
      run_command("init q")
    else
      setup_failed("failed to add sensu-runsvdir to inittab")
    end
  end
end

def setup_runsvdir_systemd
  if run_command("cp /usr/share/sensu/systemd/sensu-runsvdir.service /etc/systemd/system/sensu-runsvdir.service")
    unless run_command("systemctl status sensu-runsvdir.service", 1, false)
      run_command("systemctl daemon-reload")
      unless run_command("systemctl start sensu-runsvdir.service")
        setup_failed("failed to start systemd service: sensu-runsvdir.service")
      end
    end
  else
    setup_failed("failed to create systemd service: /etc/systemd/system/sensu-runsvdir.service")
  end
end

def configure
  ohai = Ohai::System.new
  ohai.require_plugin("os")
  ohai.require_plugin("platform")
  case ohai.platform
  when "ubuntu"
    setup_runsvdir_upstart
  when "redhat", "centos", "rhel", "scientific"
    if ohai.platform_version =~ /^6/
      setup_runsvdir_upstart
    else
      setup_runsvdir_sysvinit
    end
  when "fedora"
    if ohai.platform_version.to_i > 15
      setup_runsvdir_systemd
    end
  else
    setup_runsvdir_sysvinit
  end
  puts "done"
  exit
end

def configured?
  run_command("pgrep -f /opt/sensu/embedded/bin/runsvdir")
end

def tail(service='*')
  system("tail -f /var/log/sensu/#{service}.log")
end

def help
  puts "#{$0}: command (subcommand)"
  puts <<-EOH
  All commands except "service-list" can be prepended
  with a service name, and will only apply to that service.

  # Would show the status of all services
  $ #{$0} status

  # Would show only the status of sensu-client
  $ #{$0} sensu-client status

service-list
    List all the services (enabled services appear with a *.)
status
    Show the status of all the services.
tail
    Watch the service logs of all enabled services.
enable
    Enable services, and start them if they are down.
disable
    Disable services, and stop them if they are running.
start
    Start services if they are down, and restart them if they stop.
stop
    Stop the services, and do not restart them.
restart
    Stop the services if they are running, then start them again.
once
    Start the services if they are down. Do not restart them if they stop.
hup
    Send the services a HUP.
term
    Send the services a TERM.
int
    Send the services an INT.
kill
    Send the services a KILL.
EOH
  exit 1
end

case ARGV[0]
when "service-list"
  service_list
when "configure", "reconfigure"
  configure
when "configured", "configured?"
  configured?
when "tail"
  tail
else
  if sv_command_list.include?(ARGV[0])
    run_sv_command(ARGV[0])
  elsif get_all_services.include?(ARGV[0])
    if sv_command_list.include?(ARGV[1])
      run_sv_command(ARGV[1], ARGV[0])
    elsif ARGV[1] == "enable"
      enable_service(ARGV[0])
    elsif ARGV[1] == "disable"
      disable_service(ARGV[0])
    elsif ARGV[1] == "tail"
      tail(ARGV[0])
    end
  else
    help
  end
end
