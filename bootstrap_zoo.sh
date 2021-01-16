# Downloading and installing openjdk
echo "Downloading and installing openjdk..."
curl https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_linux-x64_bin.tar.gz > /tmp/openjsk-15.0.1.tar.gz
tar -xf /tmp/openjsk-15.0.1.tar.gz -C /etc/
rm /tmp/openjsk-15.0.1.tar.gz
export PATH=$PATH:/etc/jdk-15.0.1/bin

# install dependencies
echo "Installing dependencies..."
yum install -y cppunit python-setuptools openssl openssl-devel nano

# download zookeeper
echo "Dowloading zookeepeer..."
curl https://apache-mirror.rbc.ru/pub/apache/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz > /tmp/apache-zookeeper-3.6.2-bin.tar.gz
tar -xf /tmp/apache-zookeeper-3.6.2-bin.tar.gz -C /etc/
rm /tmp/apache-zookeeper-3.6.2-bin.tar.gz

# cp standalone cfg
# cp /vagrant/zoo_standalone.cfg /etc/apache-zookeeper-3.6.2-bin/conf/zoo.cfg

# cp replicated config
cp /vagrant/zoo_replicated.cfg /etc/apache-zookeeper-3.6.2-bin/conf/zoo.cfg

# Create an initialization marker file initialize in the same directory as myid. 
# This file indicates that an empty data directory is expected. 
# When present, an empty database is created and the marker file deleted. 
# When not present, an empty data directory will mean this peer will not have voting rights 
# and it will not populate the data directory until it communicates with an active leader. 
# Intended use is to only create this file when bringing up a new ensemble.
mkdir /var/lib/zookeeper
touch /var/lib/zookeeper/initialize

# creating myid file, expecting zoo id in 4 byte
# ex zoo1, zoo2, zoo3
hostname | cut -b 4 >> /var/lib/zookeeper/myid

# start zookeeper
/etc/apache-zookeeper-3.6.2-bin/bin/zkServer.sh start
# cd /etc/apache-zookeeper-3.6.2-bin/ && java -cp zookeeper.jar:lib/*:conf org.apache.zookeeper.server.quorum.QuorumPeerMain /etc/apache-zookeeper-3.6.2-bin/conf/zoo.cfg