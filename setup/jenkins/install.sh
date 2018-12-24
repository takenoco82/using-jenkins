#!/bin/bash
set -eux

# usage
#   curl -sL https://raw.githubusercontent.com/takenoco82/using-jenkins/master/setup/jenkins/install.sh | sh

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

  # Add to `docker` group
  cat /etc/group | grep docker
  if [[ $? -ne 0 ]]; then
      sudo groupadd docker
  fi
  sudo usermod -aG docker $USER  # 一度 exit する必要があるっぽい
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
  rm -rf ~/git/using-jenkins
  if [[ ! -e ~/git ]]; then
    mkdir ~/git
  fi
  cd ~/git
  git clone https://github.com/takenoco82/using-jenkins.git
}

# master・slave間で使用ssh keyを作成する
function generate_ssh_key() {
  if [[ ! -e ~/jenkins_home/.ssh ]]; then
    sudo mkdir -p ~/jenkins_home/.ssh
  fi
  if [[ ! -e ~/jenkins_home/.ssh/id_rsa ]]; then
    sudo ssh-keygen -t rsa -b 4096 -f ~/jenkins_home/.ssh/id_rsa -N ''
    sudo cp -p ~/jenkins_home/.ssh/id_rsa.pub ~/jenkins_home/.ssh/authorized_keys
  fi

  # そのままだと書き込み権限がなくて怒られるので権限を設定
  sudo chown -R 1000 ~/jenkins_home
  # authorized_keys はユーザのみしか利用できないようにする
  sudo chmod 600 ~/jenkins_home/.ssh/authorized_keys
}

# セットアップ時のadminのパスワードを表示する
function show_initial_admin_password() {
  if [[ -e /var/jenkins_home/secrets/initialAdminPassword ]]; then
    password=$(docker exec jenkins-master /bin/bash -c 'cat /var/jenkins_home/secrets/initialAdminPassword')
    echo Input initial Administrator password: ${password}
  fi
}

# main
echo start install
install_docker
install_git
clone_repository
generate_ssh_key
cd ~/git/using-jenkins && make init && make start
cat <<__EOF__

See on http://JENKINS_SERVER:8080 in your browser

__EOF__
show_initial_admin_password
