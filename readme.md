### Описание  
Данная конфигурация разворачивает кластер zookeeper из трех хостов, и два хоста кликхауса, которые реплицируются через данный zookeeper  


### Запуск
1. Устанавляваем vagrant  https://www.vagrantup.com/docs/installation  
2. Устанавливаем vagrant-hosts `vagrant plugin install vagrant-hosts`  
3. `vagrant up`  

### Импорт данных
clickhouse-client --query "INSERT INTO test.hits_replica FORMAT TSV" --max_insert_block_size=100000 < ./hits_v1_head100.tsv