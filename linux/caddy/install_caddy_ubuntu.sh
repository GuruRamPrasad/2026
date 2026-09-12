#!/bin/bash

sudo apt update
sudo apt install -y curl debian-keyring debian-archive-keyring apt-transport-https

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
| sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
| sudo tee /etc/apt/sources.list.d/caddy-stable.list

sudo apt update
sudo apt install -y caddy

sudo systemctl enable caddy
sudo systemctl start caddy

echo "Caddy installed successfully"

echo "Check Version: caddy version"
echo "Check Status: sudo systemctl status caddy"
echo "Stop Caddy: sudo systemctl stop caddy"
echo "Start Caddy: sudo systemctl start caddy"
echo "Apply Config Changes: sudo systemctl reload caddy"

