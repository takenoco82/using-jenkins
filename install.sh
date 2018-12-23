#!/bin/bash
set -eux

# usage
#   curl -sL https://raw.githubusercontent.com/takenoco82/using-jenkins/master/install.sh | sh

#
# CentOSにdocker, docker-composeをインストールする
#   https://docs.docker.com/install/linux/docker-ce/centos/
#   https://github.com/docker/compose/releases
#
function install_docker() {
  # Uninstall old versions
  sudo yum remove -y docker \
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

  # Install docker-compose
  docker-compose --version &>/dev/null
  if [[ $? -ne 0 ]]; then
      curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o docker-compose
      sudo mv docker-compose /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose
  fi
}

#
# gitをインストール
#   https://stackoverflow.com/questions/21820715/how-to-install-latest-version-of-git-on-centos-7-x-6-x
#
function install_git() {
  git --version &>/dev/null
  if [[ $? -ne 0 ]]; then
    sudo yum -y install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
    sudo yum install -y git
  fi
}

function clone_repository() {
  if [[ ! -e ~/git/using-jenkins/README.md ]]; then
    mkdir ~/git && cd $_
    git clone https://github.com/takenoco82/using-jenkins.git
  fi
}


# main
echo start install
install_docker
install_git
cd ~/git/using-jenkins && make start
