# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "gusztavvargadr/ubuntu-desktop"
    config.vm.network "public_network"
    #config.vm.box_check_update = false
  
    config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "8192"
      vb.cpus = 4
    end
  
    if Vagrant.has_plugin?("vagrant-vbguest") then
      config.vbguest.auto_update = false
    end
  
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/build.yml"
    end
  end