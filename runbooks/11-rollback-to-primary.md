# Runbook 11: Rollback to Mumbai Primary Region

## Severity
P2 High

## Objective
Safely move traffic back to Mumbai after disaster recovery.

## Pre-Checks
- Mumbai EKS healthy
- Aurora consistency verified
- Kafka lag zero
- Redis healthy
- Compliance approval received

## Commands

~~~bash
aws rds describe-global-clusters
kubectl config use-context paysecure-mumbai
kubectl get pods -n production
kubectl get nodes
~~~

## Traffic Shift

~~~bash
aws route53 change-resource-record-sets \
  --hosted-zone-id HOSTED_ZONE_ID \
  --change-batch file://route53-failback-mumbai.json
~~~

## Validation
- API health check passing
- Payment success rate normal
- No duplicate transactions
- Settlement totals verified

## Post Actions
- Update incident report
- Archive logs
- Conduct RCA
