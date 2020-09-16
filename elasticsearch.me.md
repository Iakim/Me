# Steps to analyze index/shard broken :/

### Show shards stats

    [root@node208 bin]# curl -XGET node208:9200/_cluster/allocation/explain?pretty
    {
      "index" : "node208-internet-20154",
      "shard" : 2,
      "primary" : true,
      "current_state" : "unassigned",
      "unassigned_info" : {
      "reason" : "CLUSTER_RECOVERED",
      "at" : "2020-05-22T13:10:32.695Z",
      "last_allocation_status" : "no_valid_shard_copy"
      },
      "can_allocate" : "no_valid_shard_copy",
      "allocate_explanation" : "cannot allocate because all found copies of the shard are either stale or corrupt",
      "node_allocation_decisions" : [
      {
        "node_id" : "AnbH4N9NRnmDtIxLqlC0aA",
        "node_name" : "node209",
        "transport_address" : "10.19.0.209:9300",
        "node_attributes" : {
        "ml.machine_memory" : "50437959680",
        "ml.max_open_jobs" : "20",
        "xpack.installed" : "true",
        "ml.enabled" : "true"
        },
        "node_decision" : "no",
        "store" : {
        "found" : false
        }
      },
      {
        "node_id" : "O2zHgmD6TPGC7QVbib6b-g",
        "node_name" : "node208",
        "transport_address" : "10.19.0.208:9300",
        "node_attributes" : {
        "ml.machine_memory" : "50437959680",
        "ml.max_open_jobs" : "20",
        "xpack.installed" : "true",
        "ml.enabled" : "true"
        },
        "node_decision" : "no",
        "store" : {
        "in_sync" : true,
        "allocation_id" : "v8Och7-CQJiSaAPCCQJuSQ",
        "store_exception" : {
          "type" : "corrupt_index_exception",
          "reason" : "failed engine (reason: [search execution corruption failure]) (resource=preexisting_corruption)",
          "caused_by" : {
          "type" : "i_o_exception",
          "reason" : "failed engine (reason: [search execution corruption failure])",
          "caused_by" : {
            "type" : "corrupt_index_exception",
            "reason" : "Corrupted: docID=10756, docBase=21, chunkDocs=26, numDocs=214929 (resource=MMapIndexInput(path=\"/opt/elasticsearch/indice/nodes/0/indices/d6fgGFCZRdurdZEpEZi84w/2/index/_1bb.fdt\"))"
          }
          }
        }
        }
      },
      {
        "node_id" : "Z80uMhmYQnSqfMY4M7wXug",
        "node_name" : "node210",
        "transport_address" : "10.19.0.210:9300",
        "node_attributes" : {
        "ml.machine_memory" : "50437959680",
        "xpack.installed" : "true",
        "ml.max_open_jobs" : "20",
        "ml.enabled" : "true"
        },
        "node_decision" : "no",
        "store" : {
        "found" : false
        }
      }
      ]
    }


### List index in the node mencioned of shard failed

    [root@node208 ~]# ll /opt/elasticsearch/indice/nodes/0/indices/d6fgGFCZRdurdZEpEZi84w/2/index/_1bb.fdt
    -rw-r--r-- 1 elasticsearch elasticsearch 1741215525 Apr 29  2019 /opt/elasticsearch/indice/nodes/0/indices/d6fgGFCZRdurdZEpEZi84w/2/index/_1bb.fdt


### Get the id and index name of shard failed

    [root@node208 ~]# curl -XGET node208:9200/_cat/shards?h=index,shard,prirep,state,unassigned.reason| grep UNASSIGNED
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                     Dload  Upload   Total   Spent    Left  Speed
    100   407  100   407    0     0   8301      0 --:--:-- --:--:-- --:--:--  8479
    node208-internet-20154 2 p UNASSIGNED CLUSTER_RECOVERED

### Stop elasticsearch cluster (all nodes)

    [root@node208 bin]# ./elasticsearch stop

### Remove corrupted datata from shard

    [root@node208 bin]# ./elasticsearch-shard remove-corrupted-data --index node208-internet-20154 --shard-id 2 -v

### We saved 1.178.974 of documents in this case :)
			
    0.62% total deletions; 1186369 documents; 7395 deleteions


### Start elasticsearch again (all nodes)

    [root@node208 bin]# ./elasticsearch start

### Allocate shard in the cluster again

    [root@node208 bin]# curl -X POST "node208:9200/_cluster/reroute?pretty" -H 'Content-Type: application/json' -d '{
      "commands" : [
        {
          "allocate_stale_primary" : {
            "index" : "node208-internet-20154",
            "shard" : 2,
            "node" : "O2zHgmD6TPGC7QVbib6b-g",
            "accept_data_loss" : false
          }
        }
      ]
    }'

### Change max_result_window of default (10.000) to variable of envioriments (in my case 4.000)

    [root@node208 bin]# curl -XPUT "node208:9200/liferay-internet-20154/_settings" -d '{ "index" : { "max_result_window" : 4000 } }'
   
-----------------------------------------------------------------------------------------------------------------------------------------------

# Create a Backup and Restore index

## Create a folder to backup and change the permissions to elastic

    mkdir -p /var/backup_index
    chown -R elasticsearch. /var/backup_index

## Add the path.repo in elasticsearch.yml

    path.repo: "/var"
  
  OR
  
    path.repo: ["/mount/backups", "/mount/longterm_backups"]
    
## Register repository

	curl -X PUT "localhost:9200/_snapshot/backup_index?pretty" -H 'Content-Type: application/json' -d 
	'
	{
	  "type": "fs",
	  "settings": {
	    "location": "/var/backup_index",
	    "compress": true
	  }
	}
	'

## Create snapshot, by default all index are included, for my example I choose only two: iakim and metricbeat.

    curl -X PUT "localhost:9200/_snapshot/backup_index/snapshot_1?wait_for_completion=true&pretty" -H 'Content-Type: application/json' -d'
    {
      "indices": "iakim,metricbeat-7.8.1-2020.08.13-000001",
      "ignore_unavailable": true,
      "include_global_state": false
    }
    '
    
## See your snapshot

    curl -X GET "localhost:9200/_snapshot/backup_index/snapshot_1?pretty"
    ls -la /var/backup_index
    
## Delete your indexes

    curl -X DELETE "localhost:9200/iakim"
    curl -X DELETE "localhost:9200/metricbeat-7.8.1-2020.08.13-000001"
    
## Restore your indexes

    curl -X POST "localhost:9200/_snapshot/backup_index/snapshot_1/_restore?pretty"
    

# SHARDS X NODES X REPLICAS

### Fragments: index distribution unit in the cluster
### Nodes: elasticsearch servers
### Replicas: are replicated fragments
### Data Node: are servers dedicated to data
### Master Node: are server dedicated to control

#### 1 - The fragment must not contain more than 40GB;
#### 2 - For each fragment you have, you must have the same number of node data;
#### 3 - For each replica you have you will need to have the same number of node data per replica;
#### 4 - For each replica added, you must have an eligible master in the datacenter.
#### 5 - You need three sites to complete minimum requeriments for this cases

#### Case 1:

The customer requested that an architer with a replica for a 110GB index be assembled.

For that, we will need 3 node data as a primary, 3 node data as a replica and 3 masters, one with a replica, other as a primary and other for complet quorum.

Data center 1

[node master + node data] P 36.6GB

[node data] P 36.6GB

[node data] P 36.6GB

Data center 2

[node master + node data] R 36.6GB

[node data] R 36.6GB

[node data] R 36.6GB

Data center 3 (Cloud)

[node master only]

#### Case 2:

The customer requested that an architer with two replica be assembled for an index with 200GB.

For that, we will need 6 data nodes as a primary, 12 data nodes as a replica and 3 masters, two as a replica and one as a primary.

Data center 1

[node master + node data] P 33.3GB

[node data] P 33.3GB

[node data] P 33.3GB

[node data] P 33.3GB

[node data] P 33.3GB

[node data] P 33.3GB

Data center 2

[node master + node data] R 33.3GB

[node data] R 33.3GB

[node data] R 33.3GB

[node data] R 33.3GB

[node data] R 33.3GB

[node data] R 33.3GB

Data center 3

[node master + node data] R 33.3GB

[node data] R 33.3GB

[node data] R 33.3GB

[node data] R 33.3GB

[node data] R 33.3GB

[node data] R 33.3GB


### Details of case 1

#### COMPLETED CLUSTER WITHOUT FAILS

		# curl -X GET 192.168.15.24:9200/_cat/nodes
		192.168.15.13  8 59  5 0.21 0.14 0.10 mdi - node-4 SITE-2
		192.168.15.9   9 60  5 0.05 0.06 0.05 di  - node-2 SITE-1
		192.168.15.10 15 59  3 0.14 0.11 0.08 di  - node-3 SITE-2
		192.168.15.6  13 60  5 0.19 0.14 0.09 mdi * node-1 SITE-1
		192.168.15.24 23 74 14 0.54 0.69 0.56 mi  - node-cloud CLOUD

#### CORRECTLY ASSIGNED FRAGMENTS AND REPLICA

		# curl -X GET 192.168.15.24:9200/_cat/shards
		iakim 1 r STARTED 186   47kb 192.168.15.13 node-4 SITE-2
		iakim 1 p STARTED 186   77kb 192.168.15.9  node-2 SITE-1
		iakim 0 p STARTED 163 37.3kb 192.168.15.6  node-1 SITE-1
		iakim 0 r STARTED 163 37.9kb 192.168.15.10 node-3 SITE-2

#### HITS
		# curl http://192.168.15.24:9200/iakim/_search?filter_path=hits.total
		{"hits":{"total":349}}

#### SITE-1 FAILS

		# curl -X GET 192.168.15.24:9200/_cat/nodes
		192.168.15.13  9 59 3 0.12 0.12 0.10 mdi - node-4 SITE-2
		192.168.15.10  9 59 3 0.08 0.10 0.08 di  - node-3 SITE-2
		192.168.15.24 25 74 8 0.50 0.67 0.56 mi  * node-cloud CLOUD

#### SHARDS OF SITE-2 AS PRIMARY

		# curl -X GET 192.168.15.24:9200/_cat/shards
		iakim 1 p STARTED    186   47kb 192.168.15.13 node-4 SITE-2
		iakim 1 r UNASSIGNED SITE-1
		iakim 0 p STARTED    163 37.9kb 192.168.15.10 node-3 SITE-2
		iakim 0 r UNASSIGNED SITE-1

#### HITS OK!

		# curl http://192.168.15.24:9200/iakim/_search?filter_path=hits.total
		{"hits":{"total":349}}

#### SITE-2 FAILS

		# curl -X GET 192.168.15.24:9200/_cat/nodes
		192.168.15.9  11 58 53 1.35 0.45 0.18 di  - node-2 SITE-1
		192.168.15.6  11 59 56 1.53 0.58 0.25 mdi - node-1 SITE-1
		192.168.15.24 26 74  9 0.34 0.56 0.53 mi  * node-cloud CLOUD

#### SITE-1 ASSIGNED SHARDS AND REPLICA

		# curl -X GET 192.168.15.24:9200/_cat/shards
		iakim 1 r STARTED 186 77.7kb 192.168.15.6 node-1 SITE-1
		iakim 1 p STARTED 186 77.7kb 192.168.15.9 node-2 SITE-1
		iakim 0 p STARTED 163 37.4kb 192.168.15.6 node-1 SITE-1
		iakim 0 r STARTED 163 37.4kb 192.168.15.9 node-2 SITE-1

#### HITS OK!

		# curl http://192.168.15.24:9200/iakim/_search?filter_path=hits.total 
		{"hits":{"total":349}}

#### COMPLETED CLUSTER WITHOUT FAILS AGAIN

		# curl -X GET 192.168.15.24:9200/_cat/nodes
		192.168.15.13 13 58 6 1.22 0.44 0.21 mdi - node-4 SITE-2
		192.168.15.9  12 58 3 0.23 0.32 0.16 di  - node-2 SITE-1
		192.168.15.10 12 58 4 1.40 0.53 0.23 di  - node-3 SITE-2
		192.168.15.6  14 59 2 0.26 0.41 0.22 mdi - node-1 SITE-1
		192.168.15.24 29 74 7 0.82 0.62 0.55 mi  * node-cloud CLOUD

#### SHARD ON NODE-1 WORK AS REPLICA, WILL CHANGE TO PRIMARY WITH PRIMARY SHARD 0 ON NODE-4

		# curl -X GET 192.168.15.24:9200/_cat/shards
		iakim 1 r STARTED 186 77.7kb 192.168.15.6  node-1 SITE-1 (CHANGE THIS)
		iakim 1 p STARTED 186 77.7kb 192.168.15.9  node-2 SITE-1
		iakim 0 r STARTED 163 38.1kb 192.168.15.10 node-3 SITE-2
		iakim 0 p STARTED 163 37.4kb 192.168.15.13 node-4 SITE-2 (WITH THIS)

#### MOVING SHARDS

		# curl -XPOST "192.168.15.24:9200/_cluster/reroute" -H 'Content-Type: application/json' -d ' 
		{
		  "commands": [
		    {
		      "move": {
			"index": "iakim", "shard": 0,
			"from_node": "node-4", "to_node": "node-1"
		      }
		    }
		  ]
		}'

#### GETTING SHARDS AGAIN

		# curl -X GET 192.168.15.24:9200/_cat/shards
		iakim 1 r STARTED 186 77.7kb 192.168.15.13 node-4 SITE-2
		iakim 1 p STARTED 186 77.7kb 192.168.15.9  node-2 SITE-1
		iakim 0 p STARTED 163 37.4kb 192.168.15.6  node-1 SITE-1
		iakim 0 r STARTED 163 38.1kb 192.168.15.10 node-3 SITE-2

#### HITS OK!

		# curl http://192.168.15.24:9200/iakim/_search?filter_path=hits.total
		{"hits":{"total":349}}
