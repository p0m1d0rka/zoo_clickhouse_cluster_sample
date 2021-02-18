#!/usr/bin/env bash

sudo -u root -i

# install docker
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl start docker

# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose

# build image
docker build -t metabase_with_clh -f /vagrant/metabase/Dockerfile /vagrant/metabase

# run metabase with postgres
docker-compose --file /vagrant/metabase/docker-compose.yml up -d