#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo service httpd status
sudo echo "Welcome to Chichi ecommerce $(hostname -f)" | sudo tee /var/www/html/index.html