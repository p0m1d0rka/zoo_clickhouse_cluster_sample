#!/usr/bin/env bash

sudo -u root -i

# installing clickhouse
yum install -y yum-utils
rpm --import https://repo.clickhouse.tech/CLICKHOUSE-KEY.GPG
yum-config-manager --add-repo https://repo.clickhouse.tech/rpm/stable/x86_64
yum install -y clickhouse-server clickhouse-client

yum install -y nano
# change owner to clickhouse for clickhouse folder
chown -R clickhouse:clickhouse /var/lib/clickhouse
chown -R clickhouse:clickhouse /etc/clickhouse-server
mkdir /var/log/clickhouse
chown -R clickhouse:clickhouse /var/log/clickhouse


# copy configuration folders
cp -r /vagrant/clickhouse_configs/config.d/ /etc/clickhouse-server/
cp -r /vagrant/clickhouse_configs/users.d/ /etc/clickhouse-server/

# up server as daemon
sudo -u clickhouse clickhouse-server --config-file=/etc/clickhouse-server/config.xml --daemon 

# wait 20s for db up
sleep 20s

# create db
clickhouse-client --query "CREATE DATABASE IF NOT EXISTS test"

# create admin user
clickhouse-client --query="CREATE USER admin IDENTIFIED WITH SHA256_PASSWORD BY '12345'"
clickhouse-client --query="SET allow_introspection_functions=1;GRANT ALL ON *.* TO admin WITH GRANT OPTION" --multiquery

# create local db
clickhouse-client --database=test --query="$(cat /vagrant/scripts/create_table_hits_local.sql)" --multiline

# create distributed view
# clickhouse-client --database=test --query="$(cat /vagrant/scripts/create_distributed_hits.sql)" --multiline