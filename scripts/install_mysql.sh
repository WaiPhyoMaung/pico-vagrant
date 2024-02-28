sudo apt update
sudo apt install -y mysql-server

# Secure MySQL installation (highly recommended)
sudo mysql_secure_installation

# Accessing MySQL (replace with your desired password)
mysql -u root -p
