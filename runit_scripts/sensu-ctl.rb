#!/opt/sensu/embedded/bin/ruby
#
# Author:: Adam Jacob (<adam@opscode.com>)
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

require 'systemu'

def service_list
  get_all_services.each do |service_name|
    print "#{service_name}"
    print "*" if service_enabled?(service_name)
    print "\n"
  end
  exit 0
end

def get_all_services_files
  Dir["/opt/sensu/sv/*"]
end

def get_all_services
  get_all_services_files.map { |f| File.basename(f) }
end

def service_enabled?(service_name)
  File.symlink?("/opt/sensu/service/#{service_name}")
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

def tail(service='*')
  system("tail -f /opt/sensu/service/#{service}/log/main/current")
end

def sv_command_list
  ["status","up","down","once","pause","cont","hup","alarm","interrupt","quit","1","2","term","kill","start","stop","restart","shutdown","force-stop","force-reload","force-restart","force-shutdown","check"]
end

def help
  puts "#{$0}: command (subcommand)"
  puts <<-EOH
  All commands except "service-list" can be prepended
  with a service name, and will only apply to that service.

  # Would show the status of all services
  $ #{$0} status

  # Would show only the status of sensu-api
  $ #{$0} sensu-api status

service-list
    List all the services (enabled services appear with a *.)
status
    Show the status of all the services.
tail
    Watch the service logs of all enabled services.
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
when "reconfigure"
  reconfigure
when "tail"
  tail
else
  if sv_command_list.include?(ARGV[0])
    run_sv_command(ARGV[0])
  elsif get_all_services.include?(ARGV[0])
    if sv_command_list.include?(ARGV[1])
      run_sv_command(ARGV[1], ARGV[0])
    elsif ARGV[1] == "tail"
      tail(ARGV[0])
    end
  else
    help
  end
end

