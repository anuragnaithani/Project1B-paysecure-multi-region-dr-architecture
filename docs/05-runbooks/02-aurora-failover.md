# Runbook 02: Aurora PostgreSQL Global Database Failover

## Severity
P1 Critical

## Objective
Promote Hyderabad Aurora cluster as writer when Mumbai database is unavailable.

## Detection
- Aurora writer unavailable
- Application write errors
- Replication lag alerts
- Database connection timeout

## Pre-Checks
~~~bash
aws rds describe-global-clusters
aws rds describe-db-clusters --region ap-south-1
aws rds describe-db-clusters --region ap-south-2
~~~

## Failover Steps
~~~bash
aws rds failover-global-cluster \
  --global-cluster-identifier paysecure-global-db \
  --target-db-cluster-identifier arn:aws:rds:ap-south-2:ACCOUNT_ID:cluster:paysecure-hyd
~~~

Update application secrets:

~~~bash
aws secretsmanager update-secret \
  --secret-id paysecure/prod/db-endpoint \
  --secret-string '{"endpoint":"paysecure-hyd.cluster-xxxx.ap-south-2.rds.amazonaws.com"}'
~~~

Restart payment services:

~~~bash
kubectl rollout restart deployment/payment-api -n production
kubectl rollout restart deployment/transaction-processor -n production
kubectl rollout restart deployment/settlement-engine -n production
~~~

## Validation
~~~bash
psql -h paysecure-hyd.cluster-xxxx.ap-south-2.rds.amazonaws.com -U app_user -d paysecure -c "select now();"
kubectl logs deployment/payment-api -n production --tail=50
~~~

## Rollback
Rollback only after old Mumbai writer is demoted and data consistency is confirmed.
