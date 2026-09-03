#!/bin/bash

set -e

echo "======================================"
echo "   Apache HTTPD Installation Script"
echo "======================================"

# Check OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
else
    OS="unknown"
fi

echo "Detected OS: $OS"
echo "Version: $VERSION"
echo

# Function to install and configure Apache
install_apache() {

    echo "Installing Apache..."

    case "$OS" in

        ubuntu|debian|linuxmint|pop)
            sudo apt-get update -y
            sudo apt-get install -y apache2

            sudo systemctl enable apache2
            sudo systemctl start apache2

            SERVICE="apache2"
            ;;

        rhel|centos|rocky|almalinux|fedora)
            if command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y httpd
            else
                sudo yum install -y httpd
            fi

            sudo systemctl enable httpd
            sudo systemctl start httpd

            SERVICE="httpd"
            ;;

        amzn)
            if command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y httpd
            else
                sudo yum install -y httpd
            fi

            sudo systemctl enable httpd
            sudo systemctl start httpd

            SERVICE="httpd"
            ;;

        opensuse*|sles)
            sudo zypper --non-interactive install apache2

            sudo systemctl enable apache2
            sudo systemctl start apache2

            SERVICE="apache2"
            ;;

        arch|manjaro)
            sudo pacman -Sy --noconfirm apache

            sudo systemctl enable httpd
            sudo systemctl start httpd

            SERVICE="httpd"
            ;;

        alpine)
            sudo apk update
            sudo apk add apache2

            sudo rc-update add apache2 default
            sudo rc-service apache2 start

            SERVICE="apache2"
            ;;

        *)
            echo "ERROR: Unsupported operating system: $OS"
            echo
            echo "Supported operating systems:"
            echo "Ubuntu / Debian / Linux Mint"
            echo "RHEL / CentOS / Rocky / AlmaLinux / Fedora"
            echo "Amazon Linux"
            echo "openSUSE / SUSE"
            echo "Arch / Manjaro"
            echo "Alpine Linux"
            exit 1
            ;;
    esac

    echo
    echo "======================================"
    echo " Apache installation completed"
    echo "======================================"

    # Verify installation
    echo
    echo "Apache Version:"
    
    if command -v apache2 >/dev/null 2>&1; then
        apache2 -v
    elif command -v httpd >/dev/null 2>&1; then
        httpd -v
    fi

    echo
    echo "Service Status:"
    
    if command -v systemctl >/dev/null 2>&1; then
        sudo systemctl status "$SERVICE" --no-pager
    else
        echo "Apache service is running."
    fi
}

# Check whether script is running as root
if [ "$EUID" -eq 0 ]; then
    echo "Running as root..."
    install_apache
else
    echo "Running as normal user..."
    install_apache
fi
