#!/bin/bash

# Get the absolute path to the directory containing this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

####################
## Docker Install ##
####################

# Add Docker's official GPG key:
apt-get update
apt-get install -y ca-certificates curl gnupg
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
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Build project docker image
docker build -t mobiroborc "${SCRIPT_DIR}"

###################
## Devices Setup ##
###################

# Create udev rules for vesc and lidar
cp ${SCRIPT_DIR}/resources/99-ydlidar.rules /etc/udev/rules.d/99-ydlidar.rules
cp ${SCRIPT_DIR}/resources/99-vesc.rules /etc/udev/rules.d/99-vesc.rules

# Apply udev changes
udevadm control --reload-rules
udevadm trigger

###################
## Hotspot Setup ##
###################

# Install network-manager for mobile hotspot
apt-get install -y network-manager
systemctl enable NetworkManager
systemctl start NetworkManager

# Disable existing network manager
systemctl stop systemd-networkd
systemctl disable systemd-networkd
mv /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.backup

# Create the Hotspot
# SSID: MobileRoboticsLabRC# (# passed in from terminal)
# PASS: mobileroboticslab
nmcli con add type wifi ifname wlan0 con-name Hostspot autoconnect yes ssid MobileRoboticsLabRC$1
nmcli con modify Hostspot 802-11-wireless.mode ap 802-11-wireless.band a ipv4.method shared
nmcli con modify Hostspot wifi-sec.key-mgmt wpa-psk
nmcli con modify Hostspot wifi-sec.psk "mobileroboticslab"
nmcli con up Hostspot

####################
## Startup Script ##
####################

cp ${SCRIPT_DIR}/resources/rc-project.service /etc/systemd/system/rc-project.service

systemctl daemon-reload
systemctl enable rc-project.service

###############
## End Setup ##
###############

echo "Reboot to start."
