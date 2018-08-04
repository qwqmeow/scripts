#!/bin/bash

echo -e "[*] fetch the lastest geth version"
# by jq
# but need to install jq manully:apt/yum install -y jq
# version=$(curl -s 'https://api.github.com/repos/ethereum/go-ethereum/releases/latest' | jq '.tag_name')

# by cut
ver=$(curl -s 'https://api.github.com/repos/ethereum/go-ethereum/releases/latest' | grep 'tag_name' | cut -d\" -f4) 
echo $ver

echo -e "[*] fetch the lastest geth commit-id"
commit_id=$(curl -s "https://api.github.com/repos/ethereum/go-ethereum/commits/${ver}" -H 'Accept: application/vnd.github.VERSION.sha' | cut -c1-8)
echo $commit_id

geth_ver="geth-linux-amd64-$(echo ${ver} | sed -e 's/^[a-zA-Z]//g')-${commit_id}"
download_link="https://gethstore.blob.core.windows.net/builds/${geth_ver}.tar.gz"

cd /opt/
echo -e "[*] geth release download to /opt/"
wget --no-check-certificate $download_link
tar zxf geth*.tar.gz
cp /opt/geth*/geth /usr/bin/
sudo chmod +x /usr/bin/geth

echo -e "[*] geth binary installed"