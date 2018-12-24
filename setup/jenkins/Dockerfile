FROM jenkinsci/blueocean:1.9.0

# install jenkins plugins
#   [Docker を使って Jenkins サーバーをローカルに構築する (プラグイン導入済み) ｜ DevelopersIO](https://dev.classmethod.jp/tool/jenkins/jenkins-on-docker/)
#   [プラグインインストール済のJenkins Dockerイメージを作成する - 理系学生日記](https://kiririmode.hatenablog.jp/entry/20161207/1481040721)
USER root
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

USER jenkins
# Generate ssh key
#   /var/jenkins_home/.ssh に作成される
RUN ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N '' && \
    cp -p ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys
