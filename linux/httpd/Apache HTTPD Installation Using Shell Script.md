# Apache HTTPD Installation Using Shell Script

This project contains a shell script to install and start the **Apache HTTPD web server** on a Linux system.

## Prerequisites

- Linux server
- `sudo` or root privileges
- Internet connectivity
- Bash shell

## Installation Steps

### 1. Create the Shell Script

Create a file named `install_httpd.sh` using nano:

```bash
nano install_httpd.sh
```

Add your HTTPD installation commands to the file and save it.

### 2. Give Execute Permission

Make the script executable:

```bash
chmod +x install_httpd.sh
```

### 3. Execute the Script

You can run the script in either of the following ways.

#### Method 1: Execute directly

```bash
./install_httpd.sh
```

#### Method 2: Execute using Bash

```bash
bash install_httpd.sh
```

## Commands Summary

```bash
nano install_httpd.sh
chmod +x install_httpd.sh
./install_httpd.sh
```

Or:

```bash
bash install_httpd.sh
```

## Verify HTTPD Installation

After running the script, verify that Apache HTTPD is installed:

```bash
httpd -v
```

Check the service status:

```bash
systemctl status httpd
```

If required, start HTTPD manually:

```bash
systemctl start httpd
```

Enable HTTPD to start automatically after reboot:

```bash
systemctl enable httpd
```

## Test the Web Server

Open the server's IP address in a web browser:

```text
http://<SERVER-IP>
```

You should see the Apache HTTPD test/default page if the installation was successful.

## Troubleshooting

Check HTTPD service logs:

```bash
journalctl -u httpd
```

Check whether HTTPD is listening on port 80:

```bash
ss -tulnp | grep :80
```

If a firewall is enabled, allow HTTP traffic on port 80:

```bash
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
```

## Project Files

```text
.
├── install_httpd.sh
└── README.md
```

## Author

Apache HTTPD Installation Script