#!/bin/sh

USER=vagrant
PASSWORD=vagrant

# Install yq to handle YAML file
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod a+x /usr/local/bin/yq
yq --version


# Path to the YAML file containing VM information
yaml_file="/home/vagrant/config/vms_config.yaml"

# Check if the configuration file exists
if [ ! -f "$yaml_file" ]; then
    echo "Error: Configuration file '$yaml_file' not found."
    exit 1
fi
# Path to the Ansible hosts file
ansible_hosts_file="/etc/ansible/hosts"

# Remove existing entries for safety
sudo sed -i '/\[.*\]/d' "$ansible_hosts_file"

# Get the hostname of the current machine
current_vm_name=$(hostname)
current_vm_hostname=$(hostname --fqdn)

# echo "vm name is $current_vm_name ."

# Read the YAML file and extract name, ip, and hostname
names=($(yq eval '.vms[].name' "$yaml_file"))
ips=($(yq eval '.vms[].ip' "$yaml_file"))
hostnames=($(yq eval '.vms[].hostname' "$yaml_file"))

# Loop through the arrays and append entries to /etc/hosts
for ((i=0; i<${#names[@]}; i++)); do
  vm_name="$(echo "${names[i]}" | tr -d ' ')"
  if [ "$vm_name" != "$current_vm_name" ]; then
    echo "${ips[i]} ${hostnames[i]}" | sudo tee -a /etc/hosts > /dev/null
  fi
done

echo "Host entries added to /etc/hosts"

# Append new entries to Ansible hosts file
echo " " | sudo tee -a "$ansible_hosts_file" > /dev/null
echo "[all]" | sudo tee -a "$ansible_hosts_file" > /dev/null

# Loop through the hostnames and append entries to Ansible hosts file
for hostname in "${hostnames[@]}"; do
  if [ "$hostname" != "$current_vm_hostname" ]; then
    echo "$hostname" | sudo tee -a "$ansible_hosts_file" > /dev/null
    # ~/scripts/ssh_pass.sh $USER $PASSWORD "${hostname[i]}" 
  fi
done

# Loop through the names and hostnames, and append entries to Ansible hosts file
for ((i=0; i<${#names[@]}; i++)); do
  vm_name="$(echo "${names[i]}" | tr -d ' ')"
  if [ "$vm_name" != "$current_vm_name" ]; then
    echo " " | sudo tee -a "$ansible_hosts_file" > /dev/null
    echo "[$(echo "${names[i]}" | tr -d ' ')]" | sudo tee -a "$ansible_hosts_file" > /dev/null
    echo "${hostnames[i]}" | sudo tee -a "$ansible_hosts_file" > /dev/null
  fi 
done

# cat /etc/ansible/hosts
dos2unix /home/vagrant/scripts/ssh_pass.sh
chmod +x /home/vagrant/scripts/ssh_pass.sh
# chown vagrant:vagrant ssh_pass.sh 

# passwordless authentication using expect scripting language
# Loop through the hostnames and append entries to Ansible hosts file
for hostname in "${hostnames[@]}"; do
  if [ "$hostname" != "$current_vm_hostname" ]; then
    # echo "$hostname" | sudo tee -a "$ansible_hosts_file" > /dev/null
    /home/vagrant/scripts/ssh_pass.sh $USER $PASSWORD "$hostname" 
  fi
done
# ~/scripts/ssh_pass.sh $USER $PASSWORD "db.test" 

# ansible-playbook ~/playbooks/install_nginx.yaml
# ansible-playbook ~/playbooks/install_db.yaml
