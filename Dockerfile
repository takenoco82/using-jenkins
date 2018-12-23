FROM jenkinsci/blueocean:1.9.0

# install jenkins plugins
#   [Docker を使って Jenkins サーバーをローカルに構築する (プラグイン導入済み) ｜ DevelopersIO](https://dev.classmethod.jp/tool/jenkins/jenkins-on-docker/)
USER root
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

USER jenkins
