#!/bin/bash

yum update -y
yum install -y httpd
systemctl enable --now httpd
echo "<h1>Hello World !</h1>" > /var/www/html/index.html

git clone <##GIT_URL##>
