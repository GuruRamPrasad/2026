# Nginx Installation Using Shell Script

This project contains a shell script to install **Nginx Web Server** on different Linux operating systems.

The script automatically detects the operating system and installs Nginx using the appropriate package manager.

## Supported Operating Systems

* Ubuntu
* Debian
* RHEL
* CentOS
* Rocky Linux
* AlmaLinux
* Amazon Linux

## Installation Steps

### 1. Create the Shell Script

Create a file named `install_nginx.sh` using nano:

```bash
nano install_nginx.sh
```

### 2. Make the Script Executable

```bash
chmod +x install_nginx.sh
```

### 3. Run the Script

You can run the script directly:

```bash
./install_nginx.sh
```

Or run it using Bash:

```bash
bash install_nginx.sh
```

## How It Works

The script automatically detects the Linux operating system.

```text
Ubuntu / Debian          → apt install nginx

RHEL / CentOS            → dnf install nginx

Rocky Linux / AlmaLinux  → dnf install nginx

Amazon Linux             → dnf install nginx
```

After installation, the script starts Nginx and enables it to start automatically when the server boots.

## Verify Nginx Installation

Check the Nginx version:

```bash
nginx -v
```

Check the Nginx service:

```bash
sudo systemctl status nginx
```

If Nginx is running correctly, you should see:

```text
Active: active (running)
```

## Test Nginx

Open a web browser and access the server IP:

```text
http://<SERVER-IP>
```

If the installation was successful, the Nginx welcome page should be displayed.
