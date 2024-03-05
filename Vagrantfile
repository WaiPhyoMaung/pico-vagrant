Vagrant.configure("2") do |config|
 
  # **VM for Nginx**
  config.vm.define "nginx" do |nginx_vm|
    nginx_vm.vm.box = "ubuntu/trusty64"  # Adjust if needed
    nginx_vm.vm.network "private_network", ip: "192.168.50.10"  
    nginx_vm.vm.synced_folder "./www", "/var/www/html"
    # nginx_vm.vm.provision :shell, path: "scripts/install_nginx.sh"    
  end

  # **VM for DB**
  config.vm.define "db" do |db_vm|
    db_vm.vm.box = "ubuntu/trusty64"  # Adjust if needed
    db_vm.vm.network "forwarded_port", guest: 3304, host: 3305 
    db_vm.vm.network "private_network", ip: "192.168.50.11"  
    # db_vm.vm.provision :shell, path: "scripts/install_mysql.sh"    
  end

  # **VM for Ansible**
  config.vm.define "ansible" do |ansible_vm|
    ansible_vm.vm.box = "ubuntu/trusty64"  # Adjust if needed
    ansible_vm.vm.network "forwarded_port", guest: 3306, host: 3307 
    ansible_vm.vm.network "private_network", ip: "192.168.50.12"
    ansible_vm.vm.provision :shell, path: "scripts/install_ansible.sh"  
    ansible_vm.vm.provision :file, source: "./." , destination: "/home/vagrant/"
    ansible_vm.vm.provision :shell, privileged: false, path: "./scripts/config_ansible.sh" 
  end
  
end
