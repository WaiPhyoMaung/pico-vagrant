Vagrant.configure("2") do |config|
  # Read VM data from the configuration file
  vm_data = YAML.load_file("./artefacts/config/vms_config.yaml")

  # Iterate through each VM definition
  vm_data["vms"].each do |vm|
    # Define VM in Vagrant configuration
    config.vm.define vm["name"].to_sym do |v|
      v.vm.box = vm["box"]
      v.vm.hostname = vm["hostname"]
      v.vm.network "private_network", ip: vm["ip"]

      if vm["cpu"] || vm["ram"] || vm["gui"]
        v.vm.provider "virtualbox" do |vb|
          v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          v.gui = vm["gui"] if vm["gui"]
          v.cpus = vm["cpu"] if vm["cpu"]
          v.memory = vm["ram"] if vm["ram"]
        end
      end

      # Handle synced_folder if present
      if vm["synced_folder"]
        v.vm.synced_folder vm["synced_folder"]["source"], vm["synced_folder"]["destination"]
      end

      # Handle forwarded_port if present
      if vm["forwarded_port"]
        v.vm.network "forwarded_port", guest: vm["forwarded_port"]["guest"], host: vm["forwarded_port"]["host"]
      end

      if vm["ansible_install"]
        # v.vm.provision :file, source: vm["ansible_install"]["source"] , destination: vm["ansible_install"]["destination"]         
        v.vm.synced_folder vm["ansible_install"]["source"], vm["ansible_install"]["destination"]       
        v.vm.provision :shell, path: vm["ansible_install"]["installation_script"]           
    end  

      # # Handle provisioning_scripts if present
      # if vm["provisioning_scripts"]
      #   vm["provisioning_scripts"].each do |script|
      #     v.vm.provision :shell, path: script
      #     v.vm.provision :shell, privileged: false, path: script
      #   end
      # end  
    end
  end
end
