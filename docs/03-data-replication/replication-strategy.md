# Data Replication Strategy

## Objective

PaySecure requires RPO below 1 minute and RTO below 5 minutes. The replication strategy must protect transaction data, merchant data, idempotency keys, cache state, Kafka events, audit logs, and operational data while keeping all regulated payment data inside India.

## Region Pair

- Primary Region: ap-south-1 Mumbai
- DR Region: ap-south-2 Hyderabad

## Replication Summary

| Component | Replication Method | Mode | Expected Lag | Recovery Action |
|---|---|---|---|---|
| Aurora PostgreSQL | Aurora Global Database | Async storage replication | Usually under 1 second | Promote Hyderabad cluster |
| DynamoDB | Global Tables | Multi-region active | Usually under 1 second | Continue using regional table |
| ElastiCache Redis | Global Datastore | Async replication | Seconds-level | Promote secondary |
| MSK Kafka | MSK Replicator / MirrorMaker 2 | Async | Seconds to minutes | Start DR consumers |
| S3 | Cross-Region Replication | Async | Minutes | Read from DR bucket |
| Secrets Manager | Replicated secrets | Async | Seconds to minutes | Use DR region secret |
| KMS | Multi-Region KMS keys | Managed replication | Near real-time | Use replica key |

## Aurora PostgreSQL

Aurora stores transaction records, settlement batches, merchant configurations, and token references. Mumbai remains the only writer during normal operation. Hyderabad has a replicated read-only cluster.

Failover process:

1. Stop application writes in Mumbai if reachable.
2. Check replication lag.
3. Promote Hyderabad Aurora cluster.
4. Update database endpoint secret.
5. Restart payment services.
6. Validate transaction writes.

Conflict handling: Aurora is treated as the system of record. The active-passive pattern prevents two independent writers.

## DynamoDB

DynamoDB stores idempotency keys and session records. Global Tables are used because idempotency must be available quickly in both regions.

Key design:

merchant_id + payment_id + request_hash

This prevents duplicate payment attempts from being processed during retries or regional failover.

## Redis

Redis is used for cache and rate limits. It is not the source of truth. Redis Global Datastore replicates cache data to Hyderabad. During failover, stale keys may be flushed and rebuilt from Aurora and DynamoDB.

## Kafka / MSK

Kafka handles transaction events, settlement triggers, audit logs, and webhook delivery. MSK Replicator or MirrorMaker 2 copies topics from Mumbai to Hyderabad.

Important topics:

- transaction-events
- settlement-events
- webhook-events
- audit-log-events
- reconciliation-events

Consumer offsets are checkpointed to reduce duplicate processing.

## S3

S3 CRR replicates reports, exports, audit artifacts, and operational logs. Regulated payment data must remain in Indian regions.

## CAP Theorem Consideration

For payment authorization and settlement, consistency is more important than availability during partition. Therefore, active-passive is preferred. In a network partition, the system must avoid double-spending even if it temporarily reduces availability.

## Monitoring Metrics

| Metric | Threshold | Severity |
|---|---|---|
| Aurora replication lag | > 500 ms for 2 checks | P1 |
| DynamoDB replication delay | > 1000 ms | P1 |
| Redis replication lag | > 2000 ms | P2 |
| Kafka consumer lag | > 10000 messages for 5 min | P2 |
| S3 replication failure | Any failed replication batch | P2 |

## Conclusion

The replication strategy balances low RPO, compliance, and payment consistency. Aurora remains single-writer, DynamoDB supports global idempotency, Redis is recoverable cache, and Kafka is replicated for event replay.
