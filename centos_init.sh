#!/usr/bin/env bash
sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
sudo setenforce 0
sudo sed -i 's\enforcing\disabled\g' /etc/selinux/config
sudo yum install -y epel-release
sudo yum install -y git gcc-c++ wget curl htop nload python2-pip vim
pip install speedtest-cli