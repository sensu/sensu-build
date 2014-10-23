# -*- mode: ruby -*-
# vi: set ft=ruby :

if ENV['SENSU_VERSION'].nil?
  raise "Must set env var 'SENSU_VERSION'"
end

if ENV['BUILD_NUMBER'].nil?
  raise "Must set env var 'BUILD_NUMBER'"
end

opscode_bento = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox'
build_boxes = {
  :centos_5_10_32  => "#{opscode_bento}/opscode_centos-5.10-i386_chef-provisionerless.box",
  :centos_5_10_64  => "#{opscode_bento}/opscode_centos-5.10_chef-provisionerless.box",
  :ubuntu_10_04_32 => "#{opscode_bento}/opscode_ubuntu-10.04-i386_chef-provisionerless.box",
  :ubuntu_10_04_64 => "#{opscode_bento}/opscode_ubuntu-10.04_chef-provisionerless.box",
  :opensuse_13_01_64 => "#{opscode_bento}/opscode_opensuse-13.1-x86_64_chef-provisionerless.box",
  :opensuse_13_01_32 => "#{opscode_bento}/opscode_opensuse-13.1-i386_chef-provisionerless.box"
}

Vagrant.configure("2") do |config|
  config.vm.provider 'virtualbox' do |vm|
    vm.memory = 750
    vm.cpus = 1
  end
  config.omnibus.chef_version = '11.12.8'
  config.vm.provision 'shell', :path => 'install_dependencies.sh'
  config.vm.provision "shell",
    :inline => "export VAGRANT_BOX=true ; \
                export SENSU_VERSION=#{ENV['SENSU_VERSION']} ; \
                export BUILD_NUMBER=#{ENV['BUILD_NUMBER']} ; \
                cd /vagrant && ./build.sh && /sbin/shutdown -h now"
  build_boxes.each do |name, url|
    config.vm.define name do |build_box|
      build_box.vm.box = name.to_s
      build_box.vm.box_url = url
    end
  end
end
