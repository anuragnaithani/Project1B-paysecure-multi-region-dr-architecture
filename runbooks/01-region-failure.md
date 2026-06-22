# Runbook 01: Complete Mumbai Region Failure

## Severity
P1 Critical

## Objective
Recover payment processing in Hyderabad within 5 minutes with RPO under 1 minute.

## Detection
- Route 53 health check failure
- Payment API success rate below 99.5%
- CloudWatch regional alarms unavailable
- Synthetic transaction failure from external probes

## Immediate Actions
1. Declare P1 incident.
2. Start incident bridge.
3. Freeze non-critical deployments.
4. Confirm Mumbai region failure from AWS Health Dashboard.
5. Check Aurora replication lag.
6. Check Kafka replication lag.
7. Check DynamoDB Global Table health.

## Failover Steps

~~~bash
aws route53 get-health-check-status --health-check-id HEALTH_CHECK_ID
aws rds describe-global-clusters
aws rds failover-global-cluster --global-cluster-identifier paysecure-global-db --target-db-cluster-identifier arn:aws:rds:ap-south-2:ACCOUNT_ID:cluster:paysecure-hyd
kubectl config use-context paysecure-hyd
kubectl scale deployment payment-api --replicas=20 -n production
kubectl scale deployment transaction-processor --replicas=20 -n production
~~~

## Validation

~~~bash
curl -f https://api.paysecure.example.com/health
curl -f https://api.paysecure.example.com/ready
~~~

## Communication
- CTO: technical status
- Compliance Head: regulatory impact
- Merchant Support: customer advisory
- Incident Commander: timeline tracking

## Rollback Condition
Do not rollback to Mumbai until Mumbai services are healthy, database consistency is verified, and transaction reconciliation is complete.
