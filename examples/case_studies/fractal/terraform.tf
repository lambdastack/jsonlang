{
   "output": {
      "frontend": {
         "value": "${google_compute_address.appserv.address}"
      }
   },
   "provider": {
      "google": {
         "account_file": "service_account_key.json",
         "project": "XXXXXXXX",
         "region": "us-central1"
      }
   },
   "resource": {
      "google_compute_address": {
         "appserv": {
            "name": "appserv"
         },
         "tilegen": {
            "name": "tilegen"
         }
      },
      "google_compute_firewall": {
         "appserv": {
            "allow": [
               {
                  "ports": [
                     "80"
                  ],
                  "protocol": "tcp"
               }
            ],
            "name": "appserv",
            "network": "${google_compute_network.fractal.name}",
            "source_ranges": [
               "0.0.0.0/0"
            ],
            "target_tags": [
               "http-server"
            ]
         },
         "cassandra": {
            "allow": {
               "ports": [
                  "9042",
                  "9160"
               ],
               "protocol": "tcp"
            },
            "name": "cassandra",
            "network": "${google_compute_network.fractal.name}",
            "source_ranges": [
               "0.0.0.0/0"
            ],
            "target_tags": [
               "cassandra-server"
            ]
         },
         "gossip": {
            "allow": {
               "ports": [
                  "7000",
                  "7001",
                  "7199"
               ],
               "protocol": "tcp"
            },
            "name": "gossip",
            "network": "${google_compute_network.fractal.name}",
            "source_ranges": [
               "0.0.0.0/0"
            ],
            "source_tags": [
               "cassandra-server"
            ],
            "target_tags": [
               "cassandra-server"
            ]
         },
         "ssh": {
            "allow": [
               {
                  "ports": [
                     "22"
                  ],
                  "protocol": "tcp"
               }
            ],
            "name": "ssh",
            "network": "${google_compute_network.fractal.name}",
            "source_ranges": [
               "0.0.0.0/0"
            ]
         },
         "tilegen": {
            "allow": [
               {
                  "ports": [
                     "8080"
                  ],
                  "protocol": "tcp"
               }
            ],
            "name": "tilegen",
            "network": "${google_compute_network.fractal.name}",
            "source_ranges": [
               "0.0.0.0/0"
            ],
            "target_tags": [
               "http-server"
            ]
         }
      },
      "google_compute_forwarding_rule": {
         "appserv": {
            "ip_address": "${google_compute_address.appserv.address}",
            "name": "appserv",
            "port_range": "80",
            "target": "${google_compute_target_pool.appserv.self_link}"
         },
         "tilegen": {
            "ip_address": "${google_compute_address.tilegen.address}",
            "name": "tilegen",
            "port_range": 8080,
            "target": "${google_compute_target_pool.tilegen.self_link}"
         }
      },
      "google_compute_http_health_check": {
         "appserv": {
            "name": "appserv",
            "port": 80
         },
         "tilegen": {
            "name": "tilegen",
            "port": 8080
         }
      },
      "google_compute_instance": {
         "appserv1": {
            "disk": {
               "image": "appserv-v20150430-2145"
            },
            "machine_type": "f1-micro",
            "metadata": {
               "startup-script": "echo '{\"database\": \"fractal\", \"database_name\": \"fractal\", \"database_pass\": \"XXXXXXXX\", \"database_user\": \"fractal\", \"db_endpoints\": [\"db1\", \"db2\", \"db3\", \"db4\", \"db5\"], \"height\": 256, \"iters\": 200, \"thumb_height\": 64, \"thumb_width\": 64, \"tilegen\": \"${google_compute_address.tilegen.address}:8080\", \"width\": 256}' > '/var/www/conf.json'\n"
            },
            "name": "appserv1",
            "network_interface": [
               {
                  "access_config": [
                     { }
                  ],
                  "network": "${google_compute_network.fractal.name}"
               }
            ],
            "service_account": [
               {
                  "scopes": [
                     "https://www.googleapis.com/auth/devstorage.read_only",
                     "https://www.googleapis.com/auth/logging.write",
                     "https://www.googleapis.com/auth/devstorage.full_control"
                  ]
               }
            ],
            "tags": [
               "terraform",
               "fractal",
               "fractal-appserv",
               "http-server"
            ],
            "zone": "us-central1-b"
         },
         "appserv2": {
            "disk": {
               "image": "appserv-v20150430-2145"
            },
            "machine_type": "f1-micro",
            "metadata": {
               "startup-script": "echo '{\"database\": \"fractal\", \"database_name\": \"fractal\", \"database_pass\": \"XXXXXXXX\", \"database_user\": \"fractal\", \"db_endpoints\": [\"db1\", \"db2\", \"db3\", \"db4\", \"db5\"], \"height\": 256, \"iters\": 200, \"thumb_height\": 64, \"thumb_width\": 64, \"tilegen\": \"${google_compute_address.tilegen.address}:8080\", \"width\": 256}' > '/var/www/conf.json'\n"
            },
            "name": "appserv2",
            "network_interface": [
               {
                  "access_config": [
                     { }
                  ],
                  "network": "${google_compute_network.fractal.name}"
               }
            ],
            "service_account": [
               {
                  "scopes": [
                     "https://www.googleapis.com/auth/devstorage.read_only",
                     "https://www.googleapis.com/auth/logging.write",
                     "https://www.googleapis.com/auth/devstorage.full_control"
                  ]
               }
            ],
            "tags": [
               "terraform",
               "fractal",
               "fractal-appserv",
               "http-server"
            ],
            "zone": "us-central1-f"
         },
         "appserv3": {
            "disk": {
               "image": "appserv-v20150430-2145"
            },
            "machine_type": "f1-micro",
            "metadata": {
               "startup-script": "echo '{\"database\": \"fractal\", \"database_name\": \"fractal\", \"database_pass\": \"XXXXXXXX\", \"database_user\": \"fractal\", \"db_endpoints\": [\"db1\", \"db2\", \"db3\", \"db4\", \"db5\"], \"height\": 256, \"iters\": 200, \"thumb_height\": 64, \"thumb_width\": 64, \"tilegen\": \"${google_compute_address.tilegen.address}:8080\", \"width\": 256}' > '/var/www/conf.json'\n"
            },
            "name": "appserv3",
            "network_interface": [
               {
                  "access_config": [
                     { }
                  ],
                  "network": "${google_compute_network.fractal.name}"
               }
            ],
            "service_account": [
               {
                  "scopes": [
                     "https://www.googleapis.com/auth/devstorage.read_only",
                     "https://www.googleapis.com/auth/logging.write",
                     "https://www.googleapis.com/auth/devstorage.full_control"
                  ]
               }
            ],
            "tags": [
               "terraform",
               "fractal",
               "fractal-appserv",
               "http-server"
            ],
            "zone": "us-central1-c"
         },
         "db1": {
            "disk": {
               "image": "cassandra-v20150430-2145"
            },
            "machine_type": "n1-standard-1",
            "metadata": {
               "startup-script": "while ! echo show version | cqlsh -u cassandra -p XXXXXXXX localhost ; do sleep 1; done\necho 'ALTER KEYSPACE system_auth WITH REPLICATION = { '\"'\"'class'\"'\"' : '\"'\"'SimpleStrategy'\"'\"', '\"'\"'replication_factor'\"'\"' : 2 };' | cqlsh -u cassandra -p XXXXXXXX localhost\necho '{\"authenticator\": \"PasswordAuthenticator\", \"authorizer\": \"AllowAllAuthorizer\", \"auto_snapshot\": true, \"batch_size_warn_threshold_in_kb\": 5, \"batchlog_replay_throttle_in_kb\": 1024, \"cas_contention_timeout_in_ms\": 1000, \"client_encryption_options\": {\"enabled\": false, \"keystore\": \"conf/.keystore\", \"keystore_password\": \"cassandra\"}, \"cluster_name\": \"Fractal Cluster\", \"column_index_size_in_kb\": 64, \"commit_failure_policy\": \"stop\", \"commitlog_directory\": \"/var/lib/cassandra/commitlog\", \"commitlog_segment_size_in_mb\": 32, \"commitlog_sync\": \"periodic\", \"commitlog_sync_period_in_ms\": 10000, \"compaction_throughput_mb_per_sec\": 16, \"concurrent_counter_writes\": 32, \"concurrent_reads\": 32, \"concurrent_writes\": 32, \"counter_cache_save_period\": 7200, \"counter_cache_size_in_mb\": null, \"counter_write_request_timeout_in_ms\": 5000, \"cross_node_timeout\": false, \"data_file_directories\": [\"/var/lib/cassandra/data\"], \"disk_failure_policy\": \"stop\", \"dynamic_snitch_badness_threshold\": 0.10000000000000001, \"dynamic_snitch_reset_interval_in_ms\": 600000, \"dynamic_snitch_update_interval_in_ms\": 100, \"endpoint_snitch\": \"SimpleSnitch\", \"hinted_handoff_enabled\": true, \"hinted_handoff_throttle_in_kb\": 1024, \"incremental_backups\": false, \"index_summary_capacity_in_mb\": null, \"index_summary_resize_interval_in_minutes\": 60, \"inter_dc_tcp_nodelay\": false, \"internode_compression\": \"all\", \"key_cache_save_period\": 14400, \"key_cache_size_in_mb\": null, \"max_hint_window_in_ms\": 10800000, \"max_hints_delivery_threads\": 2, \"memtable_allocation_type\": \"heap_buffers\", \"native_transport_port\": 9042, \"num_tokens\": 256, \"partitioner\": \"org.apache.cassandra.dht.Murmur3Partitioner\", \"permissions_validity_in_ms\": 2000, \"range_request_timeout_in_ms\": 10000, \"read_request_timeout_in_ms\": 5000, \"request_scheduler\": \"org.apache.cassandra.scheduler.NoScheduler\", \"request_timeout_in_ms\": 10000, \"row_cache_save_period\": 0, \"row_cache_size_in_mb\": 0, \"rpc_keepalive\": true, \"rpc_port\": 9160, \"rpc_server_type\": \"sync\", \"saved_caches_directory\": \"/var/lib/cassandra/saved_caches\", \"seed_provider\": [{\"class_name\": \"org.apache.cassandra.locator.SimpleSeedProvider\", \"parameters\": [{\"seeds\": \"db1, db2, db3, db4, db5\"}]}], \"server_encryption_options\": {\"internode_encryption\": \"none\", \"keystore\": \"conf/.keystore\", \"keystore_password\": \"cassandra\", \"truststore\": \"conf/.truststore\", \"truststore_password\": \"cassandra\"}, \"snapshot_before_compaction\": false, \"ssl_storage_port\": 7001, \"sstable_preemptive_open_interval_in_mb\": 50, \"start_native_transport\": true, \"start_rpc\": true, \"storage_port\": 7000, \"thrift_framed_transport_size_in_mb\": 15, \"tombstone_failure_threshold\": 100000, \"tombstone_warn_threshold\": 1000, \"trickle_fsync\": false, \"trickle_fsync_interval_in_kb\": 10240, \"truncate_request_timeout_in_ms\": 60000, \"write_request_timeout_in_ms\": 2000}' > /etc/cassandra/cassandra.yaml\n/etc/init.d/cassandra restart\nwhile ! echo show version | cqlsh -u cassandra -p XXXXXXXX $HOSTNAME ; do sleep 1; done\necho 'CREATE USER fractal WITH PASSWORD '\"'\"'XXXXXXXX'\"'\"';\nCREATE KEYSPACE fractal WITH REPLICATION = { '\"'\"'class'\"'\"' : '\"'\"'SimpleStrategy'\"'\"', '\"'\"'replication_factor'\"'\"' : 2 };\nUSE fractal;\nCREATE TABLE discoveries(Date TEXT, TimeId TIMEUUID, Text TEXT, X FLOAT, Y FLOAT, L INT, PRIMARY KEY(Date, TimeId));\nINSERT INTO discoveries (Date, TimeId, X, Y, L, Text) VALUES ('\"'\"'FIXED'\"'\"', 18063880-5a4d-11e4-ada4-247703d0f194, 0, 0, 0, '\"'\"'Zoomed Out'\"'\"');\nINSERT INTO discoveries (Date, TimeId, X, Y, L, Text) VALUES ('\"'\"'FIXED'\"'\"', 66b6d100-5a53-11e4-aa05-247703d0f194, -1.21142578125, 0.3212890625, 4, '\"'\"'Lightning'\"'\"');\nINSERT INTO discoveries (Date, TimeId, X, Y, L, Text) VALUES ('\"'\"'FIXED'\"'\"', 77ffdd80-5a53-11e4-8ccf-247703d0f194, -1.7568359375, -0.0009765625, 5, '\"'\"'Self-similarity'\"'\"');\nINSERT INTO discoveries (Date, TimeId, X, Y, L, Text) VALUES ('\"'\"'FIXED'\"'\"', 7fbf8200-5a53-11e4-804a-247703d0f194, 0.342529296875, 0.419189453125, 5, '\"'\"'Windmills'\"'\"');\nINSERT INTO discoveries (Date, TimeId, X, Y, L, Text) VALUES ('\"'\"'FIXED'\"'\"', 9ae7bd00-5a66-11e4-9c66-247703d0f194, -1.48309979046093, 0.00310595797955671, 39, '\"'\"'Star'\"'\"');\nINSERT INTO discoveries (Date, TimeId, X, Y, L, Text) VALUES ('\"'\"'FIXED'\"'\"', 75fe4480-5a7c-11e4-a747-247703d0f194, -0.244976043701172, 0.716987609863281, 10, '\"'\"'Baroque'\"'\"');\nINSERT INTO discoveries (Date, TimeId, X, Y, L, Text) VALUES ('\"'\"'FIXED'\"'\"', abf70380-5b24-11e4-8a46-247703d0f194, -1.74749755859375, 0.009002685546875, 9, '\"'\"'Hairy windmills'\"'\"');\n' | cqlsh -u cassandra -p XXXXXXXX $HOSTNAME\n"
            },
            "name": "db1",
            "network_interface": [
               {
                  "access_config": [
                     { }
                  ],
                  "network": "${google_compute_network.fractal.name}"
               }
            ],
            "service_account": [
               {
                  "scopes": [
                     "https://www.googleapis.com/auth/devstorage.read_only",
                     "https://www.googleapis.com/auth/logging.write",
                     "https://www.googleapis.com/auth/devstorage.full_control"
                  ]
               }
            ],
            "tags": [
               "terraform",
               "fractal",
               "fractal-db",
               "cassandra-server"
            ],
            "zone": "us-central1-b"
         },
         "db2": {
            "disk": {
               "image": "cassandra-v20150430-2145"
            },
            "machine_type": "n1-standard-1",
            "metadata": {
               "startup-script": "while ! echo show version | cqlsh -u cassandra -p XXXXXXXX localhost ; do sleep 1; done\n/etc/init.d/cassandra stop\nrm -rf /var/lib/cassandra/*\necho '{\"authenticator\": \"PasswordAuthenticator\", \"authorizer\": \"AllowAllAuthorizer\", \"auto_snapshot\": true, \"batch_size_warn_threshold_in_kb\": 5, \"batchlog_replay_throttle_in_kb\": 1024, \"cas_contention_timeout_in_ms\": 1000, \"client_encryption_options\": {\"enabled\": false, \"keystore\": \"conf/.keystore\", \"keystore_password\": \"cassandra\"}, \"cluster_name\": \"Fractal Cluster\", \"column_index_size_in_kb\": 64, \"commit_failure_policy\": \"stop\", \"commitlog_directory\": \"/var/lib/cassandra/commitlog\", \"commitlog_segment_size_in_mb\": 32, \"commitlog_sync\": \"periodic\", \"commitlog_sync_period_in_ms\": 10000, \"compaction_throughput_mb_per_sec\": 16, \"concurrent_counter_writes\": 32, \"concurrent_reads\": 32, \"concurrent_writes\": 32, \"counter_cache_save_period\": 7200, \"counter_cache_size_in_mb\": null, \"counter_write_request_timeout_in_ms\": 5000, \"cross_node_timeout\": false, \"data_file_directories\": [\"/var/lib/cassandra/data\"], \"disk_failure_policy\": \"stop\", \"dynamic_snitch_badness_threshold\": 0.10000000000000001, \"dynamic_snitch_reset_interval_in_ms\": 600000, \"dynamic_snitch_update_interval_in_ms\": 100, \"endpoint_snitch\": \"SimpleSnitch\", \"hinted_handoff_enabled\": true, \"hinted_handoff_throttle_in_kb\": 1024, \"incremental_backups\": false, \"index_summary_capacity_in_mb\": null, \"index_summary_resize_interval_in_minutes\": 60, \"inter_dc_tcp_nodelay\": false, \"internode_compression\": \"all\", \"key_cache_save_period\": 14400, \"key_cache_size_in_mb\": null, \"max_hint_window_in_ms\": 10800000, \"max_hints_delivery_threads\": 2, \"memtable_allocation_type\": \"heap_buffers\", \"native_transport_port\": 9042, \"num_tokens\": 256, \"partitioner\": \"org.apache.cassandra.dht.Murmur3Partitioner\", \"permissions_validity_in_ms\": 2000, \"range_request_timeout_in_ms\": 10000, \"read_request_timeout_in_ms\": 5000, \"request_scheduler\": \"org.apache.cassandra.scheduler.NoScheduler\", \"request_timeout_in_ms\": 10000, \"row_cache_save_period\": 0, \"row_cache_size_in_mb\": 0, \"rpc_keepalive\": true, \"rpc_port\": 9160, \"rpc_server_type\": \"sync\", \"saved_caches_directory\": \"/var/lib/cassandra/saved_caches\", \"seed_provider\": [{\"class_name\": \"org.apache.cassandra.locator.SimpleSeedProvider\", \"parameters\": [{\"seeds\": \"db1, db2, db3, db4, db5\"}]}], \"server_encryption_options\": {\"internode_encryption\": \"none\", \"keystore\": \"conf/.keystore\", \"keystore_password\": \"cassandra\", \"truststore\": \"conf/.truststore\", \"truststore_password\": \"cassandra\"}, \"snapshot_before_compaction\": false, \"ssl_storage_port\": 7001, \"sstable_preemptive_open_interval_in_mb\": 50, \"start_native_transport\": true, \"start_rpc\": true, \"storage_port\": 7000, \"thrift_framed_transport_size_in_mb\": 15, \"tombstone_failure_threshold\": 100000, \"tombstone_warn_threshold\": 1000, \"trickle_fsync\": false, \"trickle_fsync_interval_in_kb\": 10240, \"truncate_request_timeout_in_ms\": 60000, \"write_request_timeout_in_ms\": 2000}' > /etc/cassandra/cassandra.yaml\n/etc/init.d/cassandra start\n"
            },
            "name": "db2",
            "network_interface": [
               {
                  "access_config": [
                     { }
                  ],
                  "network": "${google_compute_network.fractal.name}"
               }
            ],
            "service_account": [
               {
                  "scopes": [
                     "https://www.googleapis.com/auth/devstorage.read_only",
                     "https://www.googleapis.com/auth/logging.write",
                     "https://www.googleapis.com/auth/devstorage.full_control"
                  ]
               }
            ],
            "tags": [
               "terraform",
               "fractal",
               "fractal-db",
               "cassandra-server"
            ],
            "zone": "us-central1-f"
         },
         "db3": {
            "disk": {
               "image": "cassandra-v20150430-2145"
            },
            "machine_type": "n1-standard-1",
            "metadata": {
               "startup-script": "while ! echo show version | cqlsh -u cassandra -p XXXXXXXX localhost ; do sleep 1; done\n/etc/init.d/cassandra stop\nrm -rf /var/lib/cassandra/*\necho '{\"authenticator\": \"PasswordAuthenticator\", \"authorizer\": \"AllowAllAuthorizer\", \"auto_snapshot\": true, \"batch_size_warn_threshold_in_kb\": 5, \"batchlog_replay_throttle_in_kb\": 1024, \"cas_contention_timeout_in_ms\": 1000, \"client_encryption_options\": {\"enabled\": false, \"keystore\": \"conf/.keystore\", \"keystore_password\": \"cassandra\"}, \"cluster_name\": \"Fractal Cluster\", \"column_index_size_in_kb\": 64, \"commit_failure_policy\": \"stop\", \"commitlog_directory\": \"/var/lib/cassandra/commitlog\", \"commitlog_segment_size_in_mb\": 32, \"commitlog_sync\": \"periodic\", \"commitlog_sync_period_in_ms\": 10000, \"compaction_throughput_mb_per_sec\": 16, \"concurrent_counter_writes\": 32, \"concurrent_reads\": 32, \"concurrent_writes\": 32, \"counter_cache_save_period\": 7200, \"counter_cache_size_in_mb\": null, \"counter_write_request_timeout_in_ms\": 5000, \"cross_node_timeout\": false, \"data_file_directories\": [\"/var/lib/cassandra/data\"], \"disk_failure_policy\": \"stop\", \"dynamic_snitch_badness_threshold\": 0.10000000000000001, \"dynamic_snitch_reset_interval_in_ms\": 600000, \"dynamic_snitch_update_interval_in_ms\": 100, \"endpoint_snitch\": \"SimpleSnitch\", \"hinted_handoff_enabled\": true, \"hinted_handoff_throttle_in_kb\": 1024, \"incremental_backups\": false, \"index_summary_capacity_in_mb\": null, \"index_summary_resize_interval_in_minutes\": 60, \"inter_dc_tcp_nodelay\": false, \"internode_compression\": \"all\", \"key_cache_save_period\": 14400, \"key_cache_size_in_mb\": null, \"max_hint_window_in_ms\": 10800000, \"max_hints_delivery_threads\": 2, \"memtable_allocation_type\": \"heap_buffers\", \"native_transport_port\": 9042, \"num_tokens\": 256, \"partitioner\": \"org.apache.cassandra.dht.Murmur3Partitioner\", \"permissions_validity_in_ms\": 2000, \"range_request_timeout_in_ms\": 10000, \"read_request_timeout_in_ms\": 5000, \"request_scheduler\": \"org.apache.cassandra.scheduler.NoScheduler\", \"request_timeout_in_ms\": 10000, \"row_cache_save_period\": 0, \"row_cache_size_in_mb\": 0, \"rpc_keepalive\": true, \"rpc_port\": 9160, \"rpc_server_type\": \"sync\", \"saved_caches_directory\": \"/var/lib/cassandra/saved_caches\", \"seed_provider\": [{\"class_name\": \"org.apache.cassandra.locator.SimpleSeedProvider\", \"parameters\": [{\"seeds\": \"db1, db2, db3, db4, db5\"}]}], \"server_encryption_options\": {\"internode_encryption\": \"none\", \"keystore\": \"conf/.keystore\", \"keystore_password\": \"cassandra\", \"truststore\": \"conf/.truststore\", \"truststore_password\": \"cassandra\"}, \"snapshot_before_compaction\": false, \"ssl_storage_port\": 7001, \"sstable_preemptive_open_interval_in_mb\": 50, \"start_native_transport\": true, \"start_rpc\": true, \"storage_port\": 7000, \"thrift_framed_transport_size_in_mb\": 15, \"tombstone_failure_threshold\": 100000, \"tombstone_warn_threshold\": 1000, \"trickle_fsync\": false, \"trickle_fsync_interval_in_kb\": 10240, \"truncate_request_timeout_in_ms\": 60000, \"write_request_timeout_in_ms\": 2000}' > /etc/cassandra/cassandra.yaml\n/etc/init.d/cassandra start\n"
            },
            "name": "db3",
            "network_interface": [
               {
                  "access_config": [
                     { }
                  ],
                  "network": "${google_compute_network.fractal.name}"
               }
            ],
            "service_account": [
               {
                  "scopes": [
                     "https://www.googleapis.com/auth/devstorage.read_only",
                     "https://www.googleapis.com/auth/logging.write",
                     "https://www.googleapis.com/auth/devstorage.full_control"
                  ]
               }
            ],
            "tags": [
               "terraform",
               "fractal",
               "fractal-db",
               "cassandra-server"
            ],
            "zone": "us-central1-c"
         },
         "tilegen1": {
            "disk": {
               "image": "tilegen-v20150430-2145"
            },
            "machine_type": "f1-micro",
            "metadata": {
               "startup-script": "echo '{\"database\": \"fractal\", \"db_endpoints\": [\"db1\", \"db2\", \"db3\", \"db4\", \"db5\"], \"height\": 256, \"iters\": 200, \"thumb_height\": 64, \"thumb_width\": 64, \"tilegen\": \"${google_compute_address.tilegen.address}:8080\", \"width\": 256}' > '/var/www/conf.json'\n"
            },
            "name": "tilegen1",
            "network_interface": [
               {
                  "access_config": [
                     { }
                  ],
                  "network": "${google_compute_network.fractal.name}"
               }
            ],
            "service_account": [
               {
                  "scopes": [
                     "https://www.googleapis.com/auth/devstorage.read_only",
                     "https://www.googleapis.com/auth/logging.write",
                     "https://www.googleapis.com/auth/devstorage.full_control"
                  ]
               }
            ],
            "tags": [
               "terraform",
               "fractal",
               "fractal-tilegen",
               "http-server"
            ],
            "zone": "us-central1-b"
         },
         "tilegen2": {
            "disk": {
               "image": "tilegen-v20150430-2145"
            },
            "machine_type": "f1-micro",
            "metadata": {
               "startup-script": "echo '{\"database\": \"fractal\", \"db_endpoints\": [\"db1\", \"db2\", \"db3\", \"db4\", \"db5\"], \"height\": 256, \"iters\": 200, \"thumb_height\": 64, \"thumb_width\": 64, \"tilegen\": \"${google_compute_address.tilegen.address}:8080\", \"width\": 256}' > '/var/www/conf.json'\n"
            },
            "name": "tilegen2",
            "network_interface": [
               {
                  "access_config": [
                     { }
                  ],
                  "network": "${google_compute_network.fractal.name}"
               }
            ],
            "service_account": [
               {
                  "scopes": [
                     "https://www.googleapis.com/auth/devstorage.read_only",
                     "https://www.googleapis.com/auth/logging.write",
                     "https://www.googleapis.com/auth/devstorage.full_control"
                  ]
               }
            ],
            "tags": [
               "terraform",
               "fractal",
               "fractal-tilegen",
               "http-server"
            ],
            "zone": "us-central1-f"
         },
         "tilegen3": {
            "disk": {
               "image": "tilegen-v20150430-2145"
            },
            "machine_type": "f1-micro",
            "metadata": {
               "startup-script": "echo '{\"database\": \"fractal\", \"db_endpoints\": [\"db1\", \"db2\", \"db3\", \"db4\", \"db5\"], \"height\": 256, \"iters\": 200, \"thumb_height\": 64, \"thumb_width\": 64, \"tilegen\": \"${google_compute_address.tilegen.address}:8080\", \"width\": 256}' > '/var/www/conf.json'\n"
            },
            "name": "tilegen3",
            "network_interface": [
               {
                  "access_config": [
                     { }
                  ],
                  "network": "${google_compute_network.fractal.name}"
               }
            ],
            "service_account": [
               {
                  "scopes": [
                     "https://www.googleapis.com/auth/devstorage.read_only",
                     "https://www.googleapis.com/auth/logging.write",
                     "https://www.googleapis.com/auth/devstorage.full_control"
                  ]
               }
            ],
            "tags": [
               "terraform",
               "fractal",
               "fractal-tilegen",
               "http-server"
            ],
            "zone": "us-central1-c"
         },
         "tilegen4": {
            "disk": {
               "image": "tilegen-v20150430-2145"
            },
            "machine_type": "f1-micro",
            "metadata": {
               "startup-script": "echo '{\"database\": \"fractal\", \"db_endpoints\": [\"db1\", \"db2\", \"db3\", \"db4\", \"db5\"], \"height\": 256, \"iters\": 200, \"thumb_height\": 64, \"thumb_width\": 64, \"tilegen\": \"${google_compute_address.tilegen.address}:8080\", \"width\": 256}' > '/var/www/conf.json'\n"
            },
            "name": "tilegen4",
            "network_interface": [
               {
                  "access_config": [
                     { }
                  ],
                  "network": "${google_compute_network.fractal.name}"
               }
            ],
            "service_account": [
               {
                  "scopes": [
                     "https://www.googleapis.com/auth/devstorage.read_only",
                     "https://www.googleapis.com/auth/logging.write",
                     "https://www.googleapis.com/auth/devstorage.full_control"
                  ]
               }
            ],
            "tags": [
               "terraform",
               "fractal",
               "fractal-tilegen",
               "http-server"
            ],
            "zone": "us-central1-b"
         }
      },
      "google_compute_network": {
         "fractal": {
            "ipv4_range": "10.0.0.0/16",
            "name": "fractal"
         }
      },
      "google_compute_target_pool": {
         "appserv": {
            "health_checks": [
               "${google_compute_http_health_check.appserv.name}"
            ],
            "instances": [
               "us-central1-b/appserv1",
               "us-central1-f/appserv2",
               "us-central1-c/appserv3"
            ],
            "name": "appserv"
         },
         "tilegen": {
            "health_checks": [
               "${google_compute_http_health_check.tilegen.name}"
            ],
            "instances": [
               "us-central1-b/tilegen1",
               "us-central1-f/tilegen2",
               "us-central1-c/tilegen3",
               "us-central1-b/tilegen4",
               "us-central1-f/tilegen5"
            ],
            "name": "tilegen"
         }
      },
      "google_dns_managed_zone": {
         "fractaldemo-com": {
            "description": "Fractal Demo DNS Zone",
            "dns_name": "wwwfractaldemo.com.",
            "name": "fractaldemo-com"
         }
      },
      "google_dns_record_set": {
         "appserv": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "appserv.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_address.appserv.address}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "appserv1": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "appserv1.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_instance.appserv1.network_interface.0.access_config.0.nat_ip}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "appserv2": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "appserv2.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_instance.appserv2.network_interface.0.access_config.0.nat_ip}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "appserv3": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "appserv3.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_instance.appserv3.network_interface.0.access_config.0.nat_ip}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "db1": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "db1.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_instance.db1.network_interface.0.access_config.0.nat_ip}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "db2": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "db2.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_instance.db2.network_interface.0.access_config.0.nat_ip}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "db3": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "db3.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_instance.db3.network_interface.0.access_config.0.nat_ip}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "tilegen": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "tilegen.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_address.tilegen.address}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "tilegen1": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "tilegen1.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_instance.tilegen1.network_interface.0.access_config.0.nat_ip}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "tilegen2": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "tilegen2.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_instance.tilegen2.network_interface.0.access_config.0.nat_ip}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "tilegen3": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "tilegen3.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_instance.tilegen3.network_interface.0.access_config.0.nat_ip}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "tilegen4": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "tilegen4.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_instance.tilegen4.network_interface.0.access_config.0.nat_ip}"
            ],
            "ttl": 300,
            "type": "A"
         },
         "www": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "www.${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "appserv.${google_dns_managed_zone.fractaldemo-com.dns_name}"
            ],
            "ttl": 300,
            "type": "CNAME"
         },
         "zone": {
            "managed_zone": "${google_dns_managed_zone.fractaldemo-com.name}",
            "name": "${google_dns_managed_zone.fractaldemo-com.dns_name}",
            "rrdatas": [
               "${google_compute_address.appserv.address}"
            ],
            "ttl": 300,
            "type": "A"
         }
      }
   }
}
