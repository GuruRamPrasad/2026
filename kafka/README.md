# Java, ZooKeeper and Kafka Installation

This project contains shell scripts to install and configure:

* Java 17
* Apache ZooKeeper 3.8.4
* Apache Kafka 3.8.1

The installation order is:

```text
Java
  ↓
ZooKeeper
  ↓
Kafka
```

## Prerequisites

* Ubuntu/Debian Linux server
* `sudo` or root privileges
* Internet connectivity
* Bash shell

---

# 1. Install Java

Java is required for ZooKeeper and Kafka.

### Create the script

```bash
nano install_java.sh
```

### Give execute permission

```bash
chmod +x install_java.sh
```

### Run the script

```bash
./install_java.sh
```

Or:

```bash
bash install_java.sh
```

### Verify Java

```bash
java -version
```

---

# 2. Install ZooKeeper

ZooKeeper is used by this Kafka installation for broker coordination.

### Create the script

```bash
nano install_zookeeper.sh
```

### Give execute permission

```bash
chmod +x install_zookeeper.sh
```

### Run the script

```bash
./install_zookeeper.sh
```

Or:

```bash
bash install_zookeeper.sh
```

### Check ZooKeeper status

```bash
sudo systemctl status zookeeper
```

### Check ZooKeeper port

```bash
sudo ss -lntp | grep 2181
```

Default ZooKeeper port:

```text
2181
```

---

# 3. Install Kafka

Make sure ZooKeeper is running before installing Kafka.

### Check ZooKeeper

```bash
sudo systemctl status zookeeper
```

### Create the Kafka installation script

```bash
nano install_kafka.sh
```

### Give execute permission

```bash
chmod +x install_kafka.sh
```

### Run the script

```bash
./install_kafka.sh
```

Or:

```bash
bash install_kafka.sh
```

### Check Kafka status

```bash
sudo systemctl status kafka
```

### Check Kafka port

```bash
sudo ss -lntp | grep 9092
```

Default Kafka port:

```text
9092
```

---

# 4. Test Kafka

## Create a Topic

```bash
/opt/kafka/bin/kafka-topics.sh \
--create \
--topic test-topic \
--bootstrap-server localhost:9092
```

## List Topics

```bash
/opt/kafka/bin/kafka-topics.sh \
--list \
--bootstrap-server localhost:9092
```

You should see:

```text
test-topic
```

---

# 5. Start Kafka Producer

Open a terminal and run:

```bash
/opt/kafka/bin/kafka-console-producer.sh \
--topic test-topic \
--bootstrap-server localhost:9092
```

Enter messages:

```text
Hello Kafka
Hello World
```

Keep the producer running.

---

# 6. Start Kafka Consumer

Open another terminal and run:

```bash
/opt/kafka/bin/kafka-console-consumer.sh \
--topic test-topic \
--bootstrap-server localhost:9092
```

You should see:

```text
Hello Kafka
Hello World
```

If the messages are received successfully, Kafka is working correctly.

---

# 7. Useful Commands

## ZooKeeper

### Start

```bash
sudo systemctl start zookeeper
```

### Stop

```bash
sudo systemctl stop zookeeper
```

### Restart

```bash
sudo systemctl restart zookeeper
```

### Status

```bash
sudo systemctl status zookeeper
```

---

## Kafka

### Start

```bash
sudo systemctl start kafka
```

### Stop

```bash
sudo systemctl stop kafka
```

### Restart

```bash
sudo systemctl restart kafka
```

### Status

```bash
sudo systemctl status kafka
```

---

# 8. Installation Order

Run the scripts in this order:

```text
1. install_java.sh
        ↓
2. install_zookeeper.sh
        ↓
3. install_kafka.sh
```

Example:

```bash
chmod +x install_java.sh
./install_java.sh

chmod +x install_zookeeper.sh
./install_zookeeper.sh

chmod +x install_kafka.sh
./install_kafka.sh
```

Or use Bash directly:

```bash
bash install_java.sh
bash install_zookeeper.sh
bash install_kafka.sh
```

---

# 9. Project Structure

Your project can be organized as:

```text
.
├── README.md
├── install_java.sh
├── install_zookeeper.sh
└── install_kafka.sh
```

---

# 10. Default Ports

| Component | Port |
| --------- | ---: |
| ZooKeeper | 2181 |
| Kafka     | 9092 |

---

# 11. Troubleshooting

### Check ZooKeeper logs

```bash
sudo journalctl -u zookeeper -f
```

### Check Kafka logs

```bash
sudo journalctl -u kafka -f
```

### Check both ports

```bash
sudo ss -lntp | grep -E '2181|9092'
```

### Check both services

```bash
sudo systemctl status zookeeper
sudo systemctl status kafka
```

---

# Summary

The provided shell scripts automate the installation of Java, ZooKeeper, and Kafka.

The required installation sequence is:

```text
Java
 ↓
ZooKeeper
 ↓
Kafka
 ↓
Create Topic
 ↓
Producer
 ↓
Consumer
```

After the producer and consumer successfully exchange messages, the Kafka installation is ready for use.
