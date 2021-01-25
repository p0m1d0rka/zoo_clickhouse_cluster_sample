# Удаляем пакеты
yum erase clickhouse-client.noarch clickhouse-common-static.x86_64 clickhouse-server.noarch 

# Удаляем каталоги
rm -rf /etc/clickhouse-client/ /etc/clickhouse-server/ /var/log/clickhouse /var/log/clickhouse-server/

# Удаляем пользователя clickhouse
userdel -r clickhouse