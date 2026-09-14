# Caddy Web Server Installation Using Shell Script

This project contains simple shell scripts to install and manage the **Caddy Web Server** on Linux operating systems.

## Supported Operating Systems

* Ubuntu
* Debian
* RHEL
* CentOS

### Installation Method

| Operating Systems | Package Manager |
| ----------------- | --------------- |
| Ubuntu            | `apt`           |
| Debian            | `apt`           |
| RHEL              | `dnf`           |
| CentOS            | `dnf`           |

---

# Ubuntu

### 1. Create the Shell Script

Create a file named `install_caddy_ubuntu.sh`:

```bash
nano install_caddy_ubuntu.sh
```

Add the Ubuntu Caddy installation script to the file and save it.

### 2. Make the Script Executable

```bash
chmod +x install_caddy_ubuntu.sh
```

### 3. Run the Script

```bash
./install_caddy_ubuntu.sh
```

You can also run the script using:

```bash
bash install_caddy_ubuntu.sh
```

---

# Debian

### 1. Create the Shell Script

```bash
nano install_caddy_debian.sh
```

Add the Debian Caddy installation script to the file and save it.

### 2. Make the Script Executable

```bash
chmod +x install_caddy_debian.sh
```

### 3. Run the Script

```bash
./install_caddy_debian.sh
```

You can also run the script using:

```bash
bash install_caddy_debian.sh
```

---

# RHEL

### 1. Create the Shell Script

```bash
nano install_caddy_rhel.sh
```

Add the RHEL Caddy installation script to the file and save it.

### 2. Make the Script Executable

```bash
chmod +x install_caddy_rhel.sh
```

### 3. Run the Script

```bash
./install_caddy_rhel.sh
```

You can also run the script using:

```bash
bash install_caddy_rhel.sh
```

---

# CentOS

### 1. Create the Shell Script

```bash
nano install_caddy_centos.sh
```

Add the CentOS Caddy installation script to the file and save it.

### 2. Make the Script Executable

```bash
chmod +x install_caddy_centos.sh
```

### 3. Run the Script

```bash
./install_caddy_centos.sh
```

You can also run the script using:

```bash
bash install_caddy_centos.sh
```

---

# Caddy Management Commands

After Caddy is installed, the following commands can be used on all supported operating systems.

### Check Version

```bash
caddy version
```

### Check Status

```bash
sudo systemctl status caddy
```

### Stop Caddy

```bash
sudo systemctl stop caddy
```

### Start Caddy

```bash
sudo systemctl start caddy
```

### Apply Configuration Changes

```bash
sudo systemctl reload caddy
```

### Caddy Configuration File

The Caddy configuration file is:

```text
/etc/caddy/Caddyfile
```

You can edit it using:

```bash
sudo nano /etc/caddy/Caddyfile
```
