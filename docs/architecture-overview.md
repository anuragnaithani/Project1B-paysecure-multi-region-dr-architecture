# Architecture Overview

## Current State
PaySecure currently runs in a single AWS Mumbai region, ap-south-1. The platform uses:
- Amazon EKS for microservices
- Aurora PostgreSQL for transactional data
- DynamoDB for idempotency and sessions
- ElastiCache Redis for cache and rate limits
- Amazon MSK Kafka for event streaming
- Route 53, ALB, WAF, KMS, CloudTrail and GuardDuty

## Target State
The target architecture uses two Indian AWS regions:

| Region | Purpose |
|---|---|
| ap-south-1 Mumbai | Primary production region |
| ap-south-2 Hyderabad | Hot standby DR region |

## DR Goals
| Metric | Target |
|---|---|
| Availability | 99.99% |
| RPO | Less than 1 minute |
| RTO | Less than 5 minutes |
| Data Residency | India-only for payment data |

## Traffic Flow
1. Users and merchants connect through Route 53.
2. Route 53 sends traffic to Mumbai ALB.
3. EKS services process payment requests.
4. Transaction data is written to Aurora PostgreSQL.
5. Idempotency keys are stored in DynamoDB Global Tables.
6. Kafka events are replicated to Hyderabad.
7. If Mumbai fails, Route 53 fails over to Hyderabad.

## Recommended Pattern
Hot standby active-passive is selected because:
- It avoids multi-writer database conflict.
- It reduces double-spend risk.
- It gives simpler compliance justification.
- It can meet RTO under 5 minutes with automation.
