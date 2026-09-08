#!/bin/bash

echo "Installing Nginx..."

sudo yum install nginx -y

echo "Starting Nginx..."
sudo systemctl start nginx

echo "Enabling Nginx at startup..."
sudo systemctl enable nginx

echo "Checking Nginx status..."
sudo systemctl status nginx --no-pager

echo "Nginx version:"
nginx -v

echo "Nginx installation completed successfully."
