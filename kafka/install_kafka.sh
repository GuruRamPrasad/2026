#!/bin/bash

set -e

echo "Installing Kafka..."

cd /tmp

wget https://archive.apache.org/dist/kafka/3.8.1/kafka_2.13-3.8.1.tgz

sudo tar -xzf kafka_2.13-3.8.1.tgz -C /opt

sudo mv /opt/kafka_2.13-3.8.1 /opt/kafka

sudo useradd -r -m -s /bin/bash kafka 2>/dev/null || true

sudo mkdir -p /var/lib/kafka

sudo chown -R kafka:kafka /opt/kafka
sudo chown -R kafka:kafka /var/lib/kafka

sudo sed -i 's#log.dirs=/tmp/kafka-logs#log.dirs=/var/lib/kafka#' /opt/kafka/config/server.properties

sudo sed -i 's#zookeeper.connect=localhost:2181#zookeeper.connect=localhost:2181#' /opt/kafka/config/server.properties

sudo tee /etc/systemd/system/kafka.service > /dev/null <<EOF
[Unit]
Description=Apache Kafka
After=network.target zookeeper.service
Requires=zookeeper.service

[Service]
Type=simple
User=kafka
Group=kafka
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
ExecStop=/opt/kafka/bin/kafka-server-stop.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable kafka
sudo systemctl start kafka

echo "Kafka installation completed."

sudo systemctl status kafka --no-pager
