# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure("2") do |config|
  # For linux users uncoment next line and comment the bento/centos-7.1
  #config.vm.box = "centos/7"
  # For windows users comment the line above and uncomment next line
  config.vm.box = "bento/centos-7.1"

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
