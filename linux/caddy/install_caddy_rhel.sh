#!/bin/bash

sudo dnf install -y 'dnf-command(copr)'
sudo dnf copr enable -y @caddy/caddy
sudo dnf install -y caddy

sudo systemctl enable caddy
sudo systemctl start caddy

echo "Caddy installed successfully"

echo "Check Version: caddy version"
echo "Check Status: sudo systemctl status caddy"
echo "Stop Caddy: sudo systemctl stop caddy"
echo "Start Caddy: sudo systemctl start caddy"
echo "Apply Config Changes: sudo systemctl reload caddy"

