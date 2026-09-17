#!/bin/bash

set -e

echo "Installing Java..."

sudo apt update
sudo apt install -y openjdk-17-jdk

echo "Java installation completed."

java -version
