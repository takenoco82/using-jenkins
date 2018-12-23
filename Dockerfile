FROM jenkinsci/blueocean:1.9.0

# install jenkins plugins
#   [Docker を使って Jenkins サーバーをローカルに構築する (プラグイン導入済み) ｜ DevelopersIO](https://dev.classmethod.jp/tool/jenkins/jenkins-on-docker/)
#   [プラグインインストール済のJenkins Dockerイメージを作成する - 理系学生日記](https://kiririmode.hatenablog.jp/entry/20161207/1481040721)
USER root
COPY plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/ref/plugins.txt)

USER jenkins
