#!/bin/bash

echo "Installing Nginx..."

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Cannot detect operating system."
    exit 1
fi

case "$ID" in

    ubuntu|debian)
        sudo apt update
        sudo apt install nginx -y
        ;;

    rhel|centos|rocky|almalinux|fedora|amzn)
        sudo dnf install nginx -y
        ;;

    *)
        echo "Unsupported operating system: $ID"
        exit 1
        ;;

esac

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

echo "Nginx installed successfully!"
echo "Version:"
nginx -v

