# Mobile Robotics Lab RC Software

## Installation

### 1. Flash SD with Ubuntu 22.04 Server 64-bit

```
login: ubuntu
password: ubuntu
new password: password
```

### 2. Install Software

```
git clone https://github.com/MobileRoboticsLab/rc-software
sudo ./rc-software/setup_host.sh <RC#>
```

### 3. Reboot

## Making Updates

### 1. Update the files in the Github

### 2. Update the RC

* Plug in RC Pi to monitor, keyboard, and ethernet
* Log into the RC Pi
* Run the following commands
```
cd ~/rc-software
git pull origin main
sudo ./update_host.sh
```
The Pi should now be updated. You can reboot to start.
