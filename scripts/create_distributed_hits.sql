CREATE TABLE test.hits_all AS test.hits_local
ENGINE = Distributed(two_shards_two_replica, test, hits_local, rand());