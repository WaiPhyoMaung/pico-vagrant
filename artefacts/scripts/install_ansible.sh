#!/bin/sh

# Install Ansible repository.
apt -y update && apt-get -y upgrade
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible -y

# Install Ansible.
apt-get update
apt-get install ansible -y

# Install expect, dos2unix & tree
apt-get install expect -y 
apt-get install dos2unix -y
apt-get install tree -y 

# Cleanup unneded packages
apt-get -y autoremove

# add user to sudo groups
# usermod -aG sudo vagrant

# lsb_release -a

# Add vagrant user to sudoers.
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Disable daily apt unattended updates.
#echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

# generating password configuration on ansible server to later access remote servers
echo vagrant | sudo -S su - vagrant -c "ssh-keygen -t rsa -f /home/vagrant/.ssh/id_rsa -q -P ''"

# Make script file executable
dos2unix /home/vagrant/scripts/config_ansible.sh
chmod +x /home/vagrant/scripts/config_ansible.sh

dos2unix /home/vagrant/config/vms_config.yaml

echo "Run ansible configuration script."
echo vagrant | sudo -S su - vagrant -c "/bin/bash /home/vagrant/scripts/config_ansible.sh"
echo "Run script done."