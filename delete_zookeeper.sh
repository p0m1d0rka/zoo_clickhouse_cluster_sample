# Удаляем java и папки зукипера
rm -rf /etc/jdk-15.0.1/ /etc/apache-zookeeper-3.6.2-bin/ /var/lib/zookeeper/

# Удаляем юзера zookeeper
userdel -r zookeeper

