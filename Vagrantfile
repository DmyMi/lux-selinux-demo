# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 21, host: 8081
  config.vm.network "forwarded_port", guest: 8080, host: 8082

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # If you don't have SSH or want to use GUI for some other reason
    # login: vagrant
    # password: vagrant
    vb.gui = true
    vb.cpus = 2
    vb.memory = "2048"
  end
  
  config.vm.provision :shell, :path => "provision.sh"
end
