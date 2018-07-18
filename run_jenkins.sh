#!/bin/bash

green='\033[0;32m'
plain='\033[0m'

get_ip(){
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    [ ! -z ${IP} ] && echo ${IP} || echo
}

cd /opt/
sudo chmod 777 /opt/
wget mirrors.jenkins-ci.org/war/latest/jenkins.war
nohup java -Dhudson.DNSMultiCast.disabled=true -jar jenkins.war &
sleep 5
echo -e "${green}[Info]${plain} wait 5s for jenkins running..."
token=$(cat ~/.jenkins/secrets/initialAdminPassword)
echo -e "${green}[Info]${plain}] initialAdminPassword: $token"
echo -e "${green}[Info]${plain}] broswer  http://$(get_ip):8080 to login"

