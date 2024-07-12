ARG JENKINS_VERSION=2.419

FROM jenkins/jenkins:${JENKINS_VERSION} 

USER root

# 添加 Tencent 源
RUN apt-get install -y apt-transport-https
# docker run --rm jenkins/jenkins:2.419 cat /etc/debian_version -> debian 11
RUN sed -i "s@http://\(deb\|security\).debian.org@https://mirrors.tencent.com@g" /etc/apt/sources.list

RUN apt-get update

# https://docs.docker.com/engine/install/debian/
RUN apt-get install ca-certificates curl gnupg
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
     "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
     "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
     tee /etc/apt/sources.list.d/docker.list > /dev/null
# 只需要安装docker客户端
RUN apt-get update && apt-get install -y docker-ce-cli

USER jenkins

