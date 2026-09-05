#!/bin/bash

echo "Installing HTTPD..."

sudo yum install httpd -y

sudo systemctl start httpd
sudo systemctl enable httpd

sudo systemctl status httpd --no-pager

echo "HTTPD installation completed successfully!"
