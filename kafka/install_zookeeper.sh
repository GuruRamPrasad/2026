#!/bin/bash

set -e

echo "Installing ZooKeeper..."

cd /tmp

wget https://archive.apache.org/dist/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz

sudo tar -xzf apache-zookeeper-3.8.4-bin.tar.gz -C /opt

sudo mv /opt/apache-zookeeper-3.8.4-bin /opt/zookeeper

sudo mkdir -p /var/lib/zookeeper

sudo cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg

sudo sed -i 's#dataDir=/tmp/zookeeper#dataDir=/var/lib/zookeeper#' /opt/zookeeper/conf/zoo.cfg

sudo useradd -r -m -s /bin/bash zookeeper 2>/dev/null || true

sudo chown -R zookeeper:zookeeper /opt/zookeeper
sudo chown -R zookeeper:zookeeper /var/lib/zookeeper

sudo tee /etc/systemd/system/zookeeper.service > /dev/null <<EOF
[Unit]
Description=Apache ZooKeeper
After=network.target

[Service]
Type=simple
User=zookeeper
Group=zookeeper
ExecStart=/opt/zookeeper/bin/zkServer.sh start-foreground
ExecStop=/opt/zookeeper/bin/zkServer.sh stop
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable zookeeper
sudo systemctl start zookeeper

echo "ZooKeeper installation completed."

sudo systemctl status zookeeper --no-pager
