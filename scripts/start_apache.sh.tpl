#! /bin/bash

sudo apt-get update
sudo apt-get install -y apache2

cat <<EOF > /var/www/html/index.html
<html>
<h1>Start apache with Terraform</h1>
<br>
<h2>DB PostgreSQL start on:</h2>
<h3>host: <font color="red">${db_host}</font></h3>
<h3>port: <font color="red">${db_port}</font></h3>
<h3>db_name: <font color="red">${db_name}</font></h3>
<h3>db_username: <font color="red">${db_username}</font></h3>
<h3>db_password: <font color="red">${db_password}</font></h3>
<h3>db_allocated_storage: <font color="red">${db_allocated_storage} GB</font></h3>
</html>
EOF

sudo systemctl start apache2
sudo systemctl enable apache2