# Active-Passive Multi-Region Design

## Overview

PaySecure adopts an Active-Passive Hot Standby architecture across AWS India regions:

- Primary: ap-south-1 (Mumbai)
- DR: ap-south-2 (Hyderabad)

Mumbai processes all production traffic during normal operations. Hyderabad remains synchronized through continuous replication and can assume production responsibilities during regional failure.

## Design Goals

- Availability: 99.99%
- RPO: < 1 minute
- RTO: < 5 minutes
- RBI compliance
- PCI-DSS v4.0 compliance
- NPCI UPI resilience requirements
- India-only data residency

## Components

### EKS

Mumbai:
- 20 worker nodes
- Full production workload

Hyderabad:
- 8 worker nodes
- Hot standby services

### Aurora PostgreSQL

- Aurora Global Database
- Mumbai writer
- Hyderabad reader
- Cross-region replication lag target < 30 seconds

### DynamoDB

- Global Tables
- Idempotency records
- Session records

### Redis

- Global Datastore
- Secondary promoted during failover

### Kafka

- MSK Replicator
- Transaction events
- Settlement events
- Audit events

## Failover Sequence

1. Route53 detects regional outage
2. Aurora global failover initiated
3. Redis promoted
4. Kafka consumers enabled
5. Hyderabad EKS scaled
6. DNS switched
7. Merchant traffic restored

## Advantages

- Strong consistency
- Lower operational complexity
- Lower cost than active-active
- Easier compliance review

## Risks

- DNS propagation delay
- Aurora promotion delay
- Human operational error

## Conclusion

Active-Passive provides the best balance between resilience, operational simplicity, regulatory compliance, and financial risk management.
