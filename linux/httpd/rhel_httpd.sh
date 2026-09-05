#!/bin/bash

echo "Installing HTTPD..."

# Install HTTPD
sudo dnf install httpd -y

# Start HTTPD
sudo systemctl start httpd

# Enable HTTPD at boot
sudo systemctl enable httpd

# Check status
sudo systemctl status httpd --no-pager

echo "HTTPD installation completed successfully!"
