# Runbook 05: ElastiCache Redis Failover

## Severity
P2 High

## Objective
Promote Hyderabad Redis Global Datastore secondary and restore cache availability.

## Detection
- Redis connection timeout
- Cache hit ratio drops suddenly
- Rate limiter errors
- ElastiCache replication lag alert

## Immediate Actions
1. Confirm Redis primary failure.
2. Disable non-critical cache writes.
3. Flush stale local app cache.
4. Promote Hyderabad Redis if Mumbai is unavailable.

## Commands
~~~bash
aws elasticache describe-global-replication-groups --region ap-south-1

aws elasticache failover-global-replication-group \
  --global-replication-group-id paysecure-redis-global \
  --primary-region ap-south-2 \
  --primary-replication-group-id paysecure-redis-hyd
~~~

Update Redis endpoint secret:

~~~bash
aws secretsmanager update-secret \
  --secret-id paysecure/prod/redis-endpoint \
  --secret-string '{"endpoint":"paysecure-redis-hyd.xxxxxx.cache.amazonaws.com"}'
~~~

Restart services:

~~~bash
kubectl rollout restart deployment/payment-api -n production
kubectl rollout restart deployment/rate-limiter -n production
~~~

## Validation
~~~bash
redis-cli -h paysecure-redis-hyd.xxxxxx.cache.amazonaws.com ping
kubectl logs deployment/rate-limiter -n production --tail=50
~~~

## Notes
Redis is treated as recoverable cache. Source of truth remains Aurora PostgreSQL and DynamoDB.
