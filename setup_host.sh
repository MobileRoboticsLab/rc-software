#!/bin/bash

# Get the absolute path to the directory containing this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Add Docker's official GPG key:
apt-get update
apt-get install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Install latest version
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Build project docker image
docker build -t mobiroborc "${SCRIPT_DIR}"

## Setup Project

# Copy udev rules
cp ${SCRIPT_DIR}/resources/99-ydlidar.rules /etc/udev/rules.d/99-ydlidar.rules
cp ${SCRIPT_DIR}/resources/99-vesc.rules /etc/udev/rules.d/99-vesc.rules

# Restart udev
udevadm control --reload-rules
udevadm trigger

# Set up Hotspot
apt-get install network-manager
nmcli con add type wifi ifname wlan0 con-name Hostspot autoconnect yes ssid MobileRoboticsLabRC$1
nmcli con modify Hostspot 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared
nmcli con modify Hostspot wifi-sec.key-mgmt wpa-psk
nmcli con modify Hostspot wifi-sec.psk "mobileroboticslab"
nmcli con up Hostspot

# Add startup script
cp ${SCRIPT_DIR}/resources/rc_project.service /etc/systemd/system/rc_project.service
cp ${SCRIPT_DIR}/run_project.sh /usr/local/bin/run_rc_project.sh
chmod +x /usr/local/bin/run_rc_project.sh

# Enable startup service
systemctl enable rc_project.service

echo "Reboot to start."