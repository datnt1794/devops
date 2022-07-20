#!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y 
systemctl start nginx
systemctl enable nginx 
echo "<h2> Hello world from $(hostname -f) </h2>" | tee /usr/share/nginx/html/index.html
