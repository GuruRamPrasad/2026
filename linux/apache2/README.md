# Apache2 Installation Using Shell Script on Ubuntu

This project contains a shell script to install and start the **Apache2 web server** on an Ubuntu Linux system.

## Prerequisites

- Ubuntu Linux server
- `sudo` or root privileges
- Internet connectivity
- Bash shell

## Installation Steps

### 1. Create the Shell Script

Create a file named `ubuntu_apache2.sh` using nano:

```bash
nano ubuntu_apache2.sh
```

Add your Apache2 installation commands to the file and save it.

### 2. Give Execute Permission

Make the script executable:

```bash
chmod +x ubuntu_apache2.sh
```

### 3. Execute the Script

You can run the script in either of the following ways.

#### Method 1: Execute directly

```bash
./ubuntu_apache2.sh
```

#### Method 2: Execute using Bash

```bash
bash ubuntu_apache2.sh
```

## Commands Summary

```bash
nano ubuntu_apache2.sh
chmod +x ubuntu_apache2.sh
./ubuntu_apache2.sh
```

Or:

```bash
bash ubuntu_apache2.sh
```

## Verify Apache2 Installation

After running the script, verify that Apache2 is installed:

```bash
apache2 -v
```

Check the service status:

```bash
systemctl status apache2
```

If required, start Apache2 manually:

```bash
systemctl start apache2
```

Enable Apache2 to start automatically after reboot:

```bash
systemctl enable apache2
```

## Test the Web Server

Open the server's IP address in a web browser:

```text
http://<SERVER-IP>
```

You should see the Apache2 Ubuntu default page if the installation was successful.

## Troubleshooting

Check Apache2 service logs:

```bash
journalctl -u apache2
```

Check the Apache2 configuration:

```bash
apache2ctl configtest
```

Check whether Apache2 is listening on port 80:

```bash
ss -tulnp | grep :80
```

If `ufw` firewall is enabled, allow HTTP traffic on port 80:

```bash
ufw allow 80/tcp
ufw reload
```

Check the firewall status:

```bash
ufw status
```

## Project Files

```text
.
├── ubuntu_apache2.sh
└── README.md
```

## Author

Ubuntu Apache2 Installation Script by Guru
