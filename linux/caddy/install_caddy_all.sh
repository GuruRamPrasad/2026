```bash
#!/bin/bash

set -e

echo "======================================"
echo "     Caddy Web Server Installation"
echo "======================================"

# Check root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Cannot detect operating system."
    exit 1
fi

echo "Detected OS: $PRETTY_NAME"
echo

case "$ID" in

    ubuntu)
        echo "Installing Caddy on Ubuntu..."

        apt update
        apt install -y debian-keyring debian-archive-keyring apt-transport-https curl

        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
            | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
            > /etc/apt/sources.list.d/caddy-stable.list

        apt update
        apt install -y caddy
        ;;

    debian)
        echo "Installing Caddy on Debian..."

        apt update
        apt install -y debian-keyring debian-archive-keyring apt-transport-https curl

        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
            | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
            > /etc/apt/sources.list.d/caddy-stable.list

        apt update
        apt install -y caddy
        ;;

    rhel|centos|rocky|almalinux)
        echo "Installing Caddy on $PRETTY_NAME..."

        dnf install -y 'dnf-command(copr)' || true

        dnf install -y 'dnf-command(config-manager)' || true

        # Enable the Caddy COPR repository
        dnf copr enable -y @caddy/caddy

        dnf install -y caddy
        ;;

    *)
        echo "Unsupported operating system: $PRETTY_NAME"
        echo
        echo "Supported systems:"
        echo "  Ubuntu"
        echo "  Debian"
        echo "  RHEL"
        echo "  CentOS"
        echo "  Rocky Linux"
        echo "  AlmaLinux"
        exit 1
        ;;

esac

echo
echo "======================================"
echo "       Caddy Installation Complete"
echo "======================================"

echo
echo "Caddy version:"
caddy version

echo
echo "Starting Caddy service..."

systemctl enable --now caddy

echo
echo "Caddy service status:"
systemctl --no-pager status caddy

echo
echo "Caddy installation completed successfully."
echo
echo "Configuration file:"
echo "/etc/caddy/Caddyfile"
echo
```
