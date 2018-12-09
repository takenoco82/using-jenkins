# using-jenkins

## CentOS に docker をインストールする
``` sh
#!/bin/bash
set -eu

#
# CentOSにdockerをインストールする
#   https://docs.docker.com/install/linux/docker-ce/centos/
#

# Uninstall old versions
sudo yum remove docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-selinux \
                docker-engine-selinux \
                docker-engine

# Install Docker CE
sudo yum install -y yum-utils \
                    device-mapper-persistent-data \
                    lvm2
sudo yum-config-manager --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo systemctl start docker
```
