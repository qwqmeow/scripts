# scripts

## get pps of a network interface
```
wget  https://raw.githubusercontent.com/qwqmeow/scripts/raw/master/netpps.sh
sh netpps.sh eth0
```

## install lastest version of geth on centos/debian
```
curl -s https://raw.githubusercontent.com/qwqmeow/scripts/raw/master/geth.sh | bash
```

## install jdk8 on centos7
```
curl -s https://raw.githubusercontent.com/qwqmeow/scripts/master/centos_install_jdk8.sh | bash
```
## run jenkins war
```
curl -s https://raw.githubusercontent.com/qwqmeow/scripts/raw/master/run_jenkins.sh | bash
```


## other

### pip
```
curl -s https://bootstrap.pypa.io/get-pip.py | python
```
### lastest docker
```
curl -s https://get.docker.com/ | sh
```

### nvm
```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.bashrc
nvm install node
```