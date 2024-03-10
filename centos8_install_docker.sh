#!/bin/bash

. /etc/init.d/functions
COLOR="echo -e \e[1;31m"
END="\e[0m"
 
${COLOR}"Begin install docker, Please wait..."${END}
install_docker(){
tee /etc/yum.repos.d/docker.repo &> /dev/null <<EOF
[docker]
name=docker
gpgcheck=0
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/8/x86_64/stable/
EOF
 
yum clean all &> /dev/null
yum erase podman buildah -y  &> /dev/null
dnf install docker-ce docker-ce-cli -y &> /dev/null \
|| { ${COLOR}"Base,Extras yum is fail,Please check yum"${END};exit; }
 
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://eph8xfli.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl enable --now docker &> /dev/null
docker version && ${COLOR}"Docker install completion"${END} || ${COLOR}"Docker install failure"${END}
}
 
rpm -q docker-ce &> /dev/null && action "Docker already install" || install_docker
