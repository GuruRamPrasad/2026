#!/bin/bash

echo "Installing Apache..."

sudo apt update -y
sudo apt install apache2 -y

sudo systemctl start apache2
sudo systemctl enable apache2

sudo systemctl status apache2 --no-pager

echo "Apache installation completed."
