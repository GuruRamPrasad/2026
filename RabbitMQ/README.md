# RabbitMQ Installation

This project contains a shell script to install **RabbitMQ** on Ubuntu/Debian-based Linux systems.

RabbitMQ is a message broker commonly used for communication between applications and microservices.

## Architecture

RabbitMQ requires Erlang/OTP as its runtime dependency.

```text
Erlang/OTP
     ↓
RabbitMQ
     ↓
Management Plugin
```

## Prerequisites

* Ubuntu/Debian Linux server
* `sudo` or root privileges
* Internet connectivity
* Bash shell

## Files

```text
.
├── install_rabbitmq.sh
└── README.md
```

The `install_rabbitmq.sh` script installs RabbitMQ, starts the service, enables the Management Plugin, and displays the RabbitMQ version and Management UI information.

---

# Installation Steps

## 1. Create or Copy the Script

Create the script file:

```bash
nano install_rabbitmq.sh
```

Add the RabbitMQ installation script to this file and save it.

---

## 2. Make the Script Executable

```bash
chmod +x install_rabbitmq.sh
```

---

## 3. Run the Script

Run the script using:

```bash
./install_rabbitmq.sh
```

Alternatively:

```bash
bash install_rabbitmq.sh
```

---

# Verify RabbitMQ Installation

## Check Service Status

```bash
sudo systemctl status rabbitmq-server
```

The service should show:

```text
Active: active (running)
```

## Check RabbitMQ Version

```bash
sudo rabbitmqctl version
```

## Check RabbitMQ Port

RabbitMQ uses port `5672` for AMQP connections.

```bash
sudo ss -lntp | grep 5672
```

---

# RabbitMQ Ports

| Port    | Purpose                   |
| ------- | ------------------------- |
| `5672`  | AMQP client connections   |
| `15672` | RabbitMQ Management UI    |
| `25672` | RabbitMQ clustering       |
| `4369`  | Erlang Port Mapper Daemon |

---

# RabbitMQ Management UI

The installation script enables the RabbitMQ Management Plugin.

Management UI port:

```text
15672
```

Open the following URL in a browser:

```text
http://SERVER-IP:15672
```

Replace `SERVER-IP` with the IP address of the RabbitMQ server.

---

# RabbitMQ User

For application access, create a dedicated RabbitMQ user instead of using the default `guest` account.

## Create User

```bash
sudo rabbitmqctl add_user admin 'StrongPassword'
```

## Give Administrator Permissions

```bash
sudo rabbitmqctl set_user_tags admin administrator
```

## Set Permissions

```bash
sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
```

## List Users

```bash
sudo rabbitmqctl list_users
```

---

# Useful RabbitMQ Commands

### Start RabbitMQ

```bash
sudo systemctl start rabbitmq-server
```

### Stop RabbitMQ

```bash
sudo systemctl stop rabbitmq-server
```

### Restart RabbitMQ

```bash
sudo systemctl restart rabbitmq-server
```

### Enable RabbitMQ at Boot

```bash
sudo systemctl enable rabbitmq-server
```

### Check Status

```bash
sudo systemctl status rabbitmq-server
```

### Check Node Status

```bash
sudo rabbitmqctl status
```

### List Queues

```bash
sudo rabbitmqctl list_queues
```

### List Exchanges

```bash
sudo rabbitmqctl list_exchanges
```

### List Users

```bash
sudo rabbitmqctl list_users
```

---

# Installation Flow

```text
Ubuntu / Debian
       ↓
apt update
       ↓
RabbitMQ Installation
       ↓
RabbitMQ Service
       ↓
Management Plugin
       ↓
5672  → Application Connections
       ↓
15672 → Management UI
```

# Summary

RabbitMQ installation can be completed using the following commands:

```bash
nano install_rabbitmq.sh
```

```bash
chmod +x install_rabbitmq.sh
```

```bash
./install_rabbitmq.sh
```

Or:

```bash
bash install_rabbitmq.sh
```

Verify the installation:

```bash
sudo systemctl status rabbitmq-server
```

```bash
sudo rabbitmqctl version
```

```bash
sudo ss -lntp | grep 5672
```

Management UI:

```text
http://SERVER-IP:15672
```
