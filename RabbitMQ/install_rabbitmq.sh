#!/bin/bash

set -e

echo "Installing RabbitMQ..."

sudo apt update

sudo apt install -y rabbitmq-server

sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server

sudo rabbitmq-plugins enable rabbitmq_management

echo "RabbitMQ installation completed."

sudo systemctl status rabbitmq-server --no-pager

echo ""
echo "RabbitMQ version:"
sudo rabbitmqctl version

echo ""
echo "Management UI:"
echo "http://SERVER-IP:15672"
