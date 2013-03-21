# -*- mode: ruby -*-
# vi: set ft=ruby :

require File.join(File.dirname(__FILE__), 'vagrant_patches')

if ENV['SENSU_VERSION'].nil?
  raise "Must set env var 'SENSU_VERSION'"
end

if ENV['BUILD_NUMBER'].nil?
  raise "Must set env var 'BUILD_NUMBER'"
end


build_boxes = {
  :centos_5_64    => 'http://vagrant.sensuapp.org/centos-5-x86_64.box',
  :centos_5_32    => 'http://vagrant.sensuapp.org/centos-5-i386.box',
  # :centos_6_64    => 'http://vagrant.sensuapp.org/centos-6-x86_64.box',
  # :centos_6_32    => 'http://vagrant.sensuapp.org/centos-6-i386.box',
  :ubuntu_1004_32 => 'http://vagrant.sensuapp.org/ubuntu-1004-i386.box',
  :ubuntu_1004_64 => 'http://vagrant.sensuapp.org/ubuntu-1004-amd64.box',
  # :ubuntu_1104_32 => 'http://vagrant.sensuapp.org/ubuntu-1104-i386.box',
  # :ubuntu_1104_64 => 'http://vagrant.sensuapp.org/ubuntu-1104-amd64.box',
  # :ubuntu_1110_32 => 'http://vagrant.sensuapp.org/ubuntu-1110-i386.box',
  # :ubuntu_1110_64 => 'http://vagrant.sensuapp.org/ubuntu-1110-amd64.box',
  # :debian_6_32    => 'http://vagrant.sensuapp.org/debian-6-i386.box',
  # :debian_6_64    => 'http://vagrant.sensuapp.org/debian-6-amd64.box',
  # :fedora_17_32 => 'http://vagrant.sensuapp.org/fedora-17-i386.box',
  # :fedora_17_64 => 'http://vagrant.sensuapp.org/fedora-17-x86_64.box',
  # :debian_5_32    => '',
  # :debian_5_64    => '',
  # :opensuse_1201_64 => '',
  # :sles_11sp2_64    => ''
}

Vagrant::Config.run do |vagrant|
  build_boxes.each_pair do |name,url|
    vagrant.vm.define name do |config|
      config.vm.box = name.to_s
      config.vm.box_url = url
      # convert underscores in hostname to '-' so ubuntu 10.04's hostname(1)
      # doesn't freak out on us.
      hostname = "sensu-build-#{name.to_s.tr('_','-')}"
      config.vm.host_name = hostname
      config.vm.customize ['modifyvm', :id, '--memory', '640']
      config.vm.customize ['modifyvm', :id, '--cpus', '1']
      config.vm.provision :shell do |shell|
        shell.inline = "export SENSU_VERSION=#{ENV['SENSU_VERSION']} ; \
                        export BUILD_NUMBER=#{ENV['BUILD_NUMBER']} ; \
                        cd /vagrant && ./build.sh && shutdown -h now"
      end      
    end
  end
end
