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

## Add the path.repo in elasticsearch.yaml

    path.repo: "/var"
  
  OR
  
    path.repo: ["/mount/backups", "/mount/longterm_backups"]
    
## Register repository

    curl -X PUT "localhost:9200/_snapshot/backup_index?pretty" -H 'Content-Type: application/json' -d'
    {
      "type": "fs",
      "settings": {
        "location": "/var/backup_index"
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

    curl -X GET -u elas "localhost:9200/_snapshot/backup_index/snapshot_1?pretty"
    ls -la /var/backup_index
    
## Delete your indexes

    curl -X DELETE http://localhost:9200/iakim
    curl -X DELETE http://localhost:9200/metricbeat-7.8.1-2020.08.13-000001
    
## Restore your indexes

    curl -X POST "localhost:9200/_snapshot/backup_index/snapshot_1/_restore?pretty"
    
