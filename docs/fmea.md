# Failure Mode and Effects Analysis

| Component | Failure Mode | Effect | S | O | D | RPN | Mitigation |
|---|---|---|---|---|---|---|---|
| Aurora | Writer failure | Payment writes fail | 9 | 3 | 2 | 54 | Multi-AZ and Global DB |
| Aurora | Replication lag | RPO breach | 9 | 4 | 3 | 108 | Lag alerts and failover block |
| DynamoDB | Conflict | Duplicate payment risk | 10 | 3 | 5 | 150 | Idempotency key design |
| Redis | Cache loss | Rate limit inconsistency | 6 | 4 | 3 | 72 | Rebuild from DB |
| Kafka | Replication lag | Event loss or delay | 8 | 4 | 4 | 128 | MSK Replicator monitoring |
| Route 53 | False positive | Unnecessary failover | 7 | 3 | 3 | 63 | Composite health checks |
| Route 53 | False negative | Traffic to failed region | 9 | 2 | 7 | 126 | Synthetic checks |
| EKS | Node failure | Service degradation | 7 | 4 | 3 | 84 | Multi-AZ node groups |
| KMS | Key unavailable | App cannot decrypt secrets | 9 | 2 | 4 | 72 | Multi-region KMS keys |
| CI/CD | Region drift | DR region stale | 8 | 4 | 5 | 160 | Dual-region deployment pipeline |
