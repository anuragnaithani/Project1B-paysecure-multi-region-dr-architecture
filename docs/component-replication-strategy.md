# Component Replication Strategy

| Component | Strategy | RPO | RTO Role |
|---|---|---|---|
| Aurora PostgreSQL | Aurora Global Database from Mumbai to Hyderabad | < 1 minute | Promote Hyderabad reader during failover |
| DynamoDB | Global Tables across Mumbai and Hyderabad | < 1 minute | Multi-region idempotency |
| ElastiCache Redis | Global Datastore async replication | Seconds-level | Promote secondary Redis |
| Kafka / MSK | MSK Replicator or MirrorMaker 2 | Seconds to minutes | Replay replicated events |
| S3 | Cross Region Replication | Minutes | Store reports, exports, logs |
| EKS | Identical clusters in both regions | N/A | Hyderabad runs minimum hot capacity |
| Route 53 | Failover routing with health checks | N/A | Redirect traffic |
| KMS | Multi-region keys | N/A | Encrypt data in both regions |
| Secrets Manager | Replicate secrets across regions | N/A | App startup in DR region |

## Aurora PostgreSQL
Aurora Global Database is used for low-lag cross-region replication. Mumbai remains the writer region during normal operation. Hyderabad has read replicas and can be promoted during regional disaster.

## DynamoDB
DynamoDB Global Tables are used for idempotency keys and sessions. Conflict risk is reduced using deterministic idempotency keys:
merchant_id + payment_id + request_hash.

## Redis
Redis is treated as recoverable cache. Critical rate limit counters are periodically snapshotted and replicated. During failover, stale cache is flushed and warmed from database.

## Kafka
MSK Replicator copies transaction events, settlement triggers, webhook events and audit logs from Mumbai to Hyderabad. Consumer offsets are checkpointed to reduce duplicate event processing.
