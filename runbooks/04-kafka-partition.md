# Runbook 04: Kafka / MSK Partition or Replication Failure

## Severity
P2 High, P1 if payment events are affected

## Objective
Restore Kafka replication and prevent transaction event loss.

## Detection
- MSK Replicator lag above threshold
- Consumer group lag increasing
- Missing settlement or webhook events
- Kafka broker unavailable

## Check Cluster Health
~~~bash
aws kafka list-clusters --region ap-south-1
aws kafka list-clusters --region ap-south-2
aws kafka describe-cluster --cluster-arn MSK_CLUSTER_ARN
~~~

## Check Consumer Lag
~~~bash
kafka-consumer-groups.sh \
  --bootstrap-server BOOTSTRAP_SERVER \
  --describe \
  --all-groups
~~~

## Immediate Actions
1. Pause non-critical consumers.
2. Keep audit-log and transaction-event topics highest priority.
3. Increase consumer replicas in healthy region.
4. Verify producer retry configuration.

## Recovery Commands
~~~bash
kubectl scale deployment webhook-dispatcher --replicas=2 -n production
kubectl scale deployment audit-logger --replicas=6 -n production
kubectl scale deployment reconciliation-worker --replicas=6 -n production
~~~

## Replay Events
~~~bash
kafka-consumer-groups.sh \
  --bootstrap-server BOOTSTRAP_SERVER \
  --group reconciliation-worker \
  --reset-offsets \
  --to-earliest \
  --topic transaction-events \
  --execute
~~~

## Validation
- Consumer lag decreasing.
- No missing transaction events.
- Audit log topic has continuous sequence.
- Settlement engine confirms event count with database count.
