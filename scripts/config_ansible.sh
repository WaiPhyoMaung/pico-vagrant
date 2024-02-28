#!/bin/sh

USER=vagrant
PASSWORD=vagrant

# add addresses to /etc/hosts 
echo "192.168.50.10 nginx.test" | sudo tee -a /etc/hosts 
echo "192.168.50.11 db.test" | sudo tee -a /etc/hosts 

echo " " | sudo tee -a /etc/ansible/hosts
echo "[all]" | sudo tee -a /etc/ansible/hosts
echo "nginx.test" | sudo tee -a /etc/ansible/hosts 
echo "db.test" | sudo tee -a /etc/ansible/hosts 

echo " " | sudo tee -a /etc/ansible/hosts
echo "[nginx]" | sudo tee -a /etc/ansible/hosts
echo "nginx.test" | sudo tee -a /etc/ansible/hosts

echo " " | sudo tee -a /etc/ansible/hosts
echo "[db]" | sudo tee -a /etc/ansible/hosts
echo "db.test" | sudo tee -a /etc/ansible/hosts

#cat /etc/ansible/hosts
dos2unix ~/scripts/ssh_pass.sh
chmod +x ~/scripts/ssh_pass.sh
#chown vagrant:vagrant ssh_pass.sh 

# password less authentication using expect scripting language
~/scripts/ssh_pass.sh $USER $PASSWORD "nginx.test" 
~/scripts/ssh_pass.sh $USER $PASSWORD "db.test" 

# ansible-playbook ~/artefacts/playbooks/install_nginx.yaml
# ansible-playbook ~/artefacts/playbooks/install_db.yaml


