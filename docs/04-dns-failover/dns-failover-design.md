# DNS Failover Design

## Objective
Route53 DNS failover redirects payment traffic from Mumbai to Hyderabad within the RTO target of 5 minutes.

## DNS Strategy
Primary record: api.paysecure.example.com -> Mumbai ALB  
Failover record: api.paysecure.example.com -> Hyderabad ALB

## Health Check
- Endpoint: /health and /ready
- Protocol: HTTPS
- Port: 443
- Interval: 10 seconds
- Failure threshold: 3
- Minimum detection time: 30 seconds

## Failover Timeline

| Stage | Time |
|---|---|
| Health check detection | 30 sec |
| Failover decision | 30 sec |
| Aurora promotion | 60-120 sec |
| EKS scale-up | 60-120 sec |
| DNS propagation | 30-60 sec |
| Total | 3-5 min |

## Decision Criteria
Failover is triggered only when Mumbai API health fails, synthetic payment checks fail, Hyderabad DR health is green, and Incident Commander approves failover.

## Validation
- API health check passes
- Synthetic payment succeeds
- Transaction appears in Aurora DR writer
- Kafka consumer lag decreases
- Merchant webhook delivery continues

## Rollback
DNS rollback to Mumbai is allowed only after Mumbai ALB, EKS, Aurora and Kafka are healthy and reconciliation is complete.
