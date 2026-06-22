# Runbook 07: Route 53 DNS Failover

## Severity
P1 Critical

## Objective
Redirect production traffic from Mumbai to Hyderabad within RTO target.

## Detection
- Route 53 health check unhealthy
- Mumbai ALB unavailable
- Payment API external probe failure
- High 5xx error rate

## Pre-Checks
~~~bash
aws route53 list-health-checks
aws route53 get-health-check-status --health-check-id HEALTH_CHECK_ID
aws elbv2 describe-load-balancers --region ap-south-1
aws elbv2 describe-load-balancers --region ap-south-2
~~~

## Failover Action
Update weighted or failover DNS record to Hyderabad ALB.

~~~bash
aws route53 change-resource-record-sets \
  --hosted-zone-id HOSTED_ZONE_ID \
  --change-batch file://route53-failover-hyd.json
~~~

## Validation
~~~bash
dig api.paysecure.example.com
curl -f https://api.paysecure.example.com/health
curl -f https://api.paysecure.example.com/ready
~~~

## Monitoring
- Payment API success rate
- P99 latency below 300 ms
- Transaction approval rate
- Merchant webhook delivery rate

## Rollback
Rollback DNS only after Mumbai ALB, EKS, Aurora, Kafka and Redis are healthy.
