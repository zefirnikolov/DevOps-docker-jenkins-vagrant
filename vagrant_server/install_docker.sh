#!/bin/bash

echo "* Add the Docker repository"
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "* Install the packages (Java, git, Docker)"
dnf install -y java-17-openjdk git docker-ce docker-ce-cli containerd.io

echo "* Start the Docker service"
systemctl enable --now docker

echo "* Adjust the group membership"
usermod -aG docker vagrant

echo "* Install Docker Compose"
mkdir -p /home/vagrant/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o /home/vagrant/.docker/cli-plugins/docker-compose
chmod +x /home/vagrant/.docker/cli-plugins/docker-compose

echo "* Adjust the firewall"
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload

echo "* Install and configure Jenkins user..."
useradd jenkins
usermod -s /bin/bash jenkins
echo -e 'Password1\nPassword1' | passwd jenkins
usermod -aG docker jenkins

echo "* Install docker compose plugin again on Jenkins user"
dnf install -y docker-compose-plugin

echo "* Install Gitea"
mkdir gitea
cd gitea
cp /vagrant/docker-compose.yml .
docker compose up -d

echo "* Add Jenkins to the sudo group ..."
echo "jenkins ALL=(ALL)    NOPASSWD: ALL" >> /etc/sudoers

