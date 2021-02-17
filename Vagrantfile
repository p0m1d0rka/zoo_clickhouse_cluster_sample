# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box_version="2004.01"
    config.vm.box = "centos/7"
  
    # workaround ssh issue https://github.com/hashicorp/vagrant/issues/10601#issuecomment-653057929
    config.ssh.config = "empty_ssh_config"
  
    config.vm.box_check_update = false
  
    config.vm.provider "virtualbox" do |vb| 
      vb.memory = "1024"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end 

    # Синхронизируем все кроме гита и данных
    config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: [".git/", "data/"]

    # Прописываем dns
    config.vm.provision :hosts do |provisioner|
      provisioner.add_host '192.168.50.11', ['zoo1']
      provisioner.add_host '192.168.50.12', ['zoo2']
      provisioner.add_host '192.168.50.13', ['zoo3']
      provisioner.add_host '192.168.50.21', ['ch01']
      provisioner.add_host '192.168.50.22', ['ch02']
      provisioner.add_host '192.168.50.31', ['metabase']
    end

    config.vm.define "zoo1", primary: true do |node|
      node.vm.hostname = "zoo1"
      node.vm.network "forwarded_port", guest: 2181, host: 2181
      node.vm.network "private_network", ip: "192.168.50.11"
      node.vm.provision :shell, path: "bootstrap_zoo.sh"
    end
  
    config.vm.define "zoo2" do |node|
      node.vm.network "forwarded_port", guest: 2181, host: 2182
      node.vm.network "private_network", ip: "192.168.50.12"
      node.vm.provision :shell, path: "bootstrap_zoo.sh"
      node.vm.hostname = "zoo2"
    end
  
    config.vm.define "zoo3" do |node|
      node.vm.hostname = "zoo3"
      node.vm.network "forwarded_port", guest: 2181, host: 2183
      node.vm.network "private_network", ip: "192.168.50.13"
      node.vm.provision :shell, path: "bootstrap_zoo.sh"
    end
  
    config.vm.define "ch01" do |node|
      node.vm.hostname = "ch01"
      node.vm.network "forwarded_port", guest: 8123, host: 8124
      node.vm.provision :shell, path: "bootstrap_ch.sh"
      node.vm.network "private_network", ip: "192.168.50.21"
      node.vm.provision :shell, inline: 'clickhouse-client --database=test --query="$(cat /vagrant/scripts/create_replicated_hits_1.sql)" --multiline'
    end
  
    config.vm.define "ch02" do |node|
      node.vm.hostname = "ch02"
      node.vm.network "forwarded_port", guest: 8123, host: 8125
      node.vm.provision :shell, path: "bootstrap_ch.sh"
      node.vm.network "private_network", ip: "192.168.50.22"
      node.vm.provision :shell, inline: 'clickhouse-client --database=test --query="$(cat /vagrant/scripts/create_replicated_hits_2.sql)" --multiline'      
    end    

    config.vm.define "metabase" do |node|
      node.vm.hostname = "metabase"
      node.vm.network "forwarded_port", guest: 3000, host: 3002
      node.vm.network "private_network", ip: "192.168.50.31"
      node.vm.provision :shell, path: 'install_docker.sh'
    end
  end