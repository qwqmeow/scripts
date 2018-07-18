#!/bin/bash
#Maintainer : qwqmeoww <i@meoww.app>

jdk8_url='http://www.oracle.com/technetwork/java/javase/downloads/index.html'
endpoint=$(curl $jdk8_download_url | grep JDK8 | awk -F "\"" '{ print $4}')
jdk8_download_url='http://www.oracle.com'$endpoint

# Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'


# check system distribution
check_system(){
    release=''

    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif grep -Eqi "debian" /etc/issue; then
        release="debian"
    elif grep -Eqi "ubuntu" /etc/issue; then
        release="ubuntu"
    elif grep -Eqi "centos|red hat|redhat" /etc/issue; then
        release="centos"
    elif grep -Eqi "debian" /proc/version; then
        release="debian"
    elif grep -Eqi "ubuntu" /proc/version; then
        release="ubuntu"
    elif grep -Eqi "centos|red hat|redhat" /proc/version; then
        release="centos"
    fi

    if 
}

# Disable selinux
disable_selinux(){
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}

# Pre-installation settings
pre_install(){
    # Check OS system
    if [ $release = 'centos' ]; then
        # centos
        sudo yum install -y vim wget curl epel-release
    fi
}


install_java(){
    if [ $release = 'centos' ]; then
        local package_url=$(curl "${jdk8_download_url}" |grep 'x64.rpm' |awk -F "\"" '{print $12}')
        echo -e "[${green}Info${plain}] download package now..."
        wget --no-check-certificate --no-cookies      --header "Cookie: oraclelicense=accept-securebackup-cookie" "${jdk8_download_url}"
        sudo rpm -ivh jdk-8u*.rpm
}

# Install java
install(){
    disable_selinux
    pre_install
    install_java
}

# Initialization step
check_system
install