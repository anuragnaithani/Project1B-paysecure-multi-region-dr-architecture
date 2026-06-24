# Current-State Architecture Documentation

## Overview

PaySecure Gateway Private Limited currently operates as a fictional mid-tier payment aggregator running entirely in a single AWS India region: ap-south-1 Mumbai. The platform processes approximately 3.2 million daily transactions worth 500 crore INR across 45,000 active merchants. The current uptime is 99.92%, which equals roughly 7 hours of downtime per year. This current state is not sufficient for the required target of 99.99% availability, RPO below 1 minute, and RTO below 5 minutes.

The current architecture is designed around a single-region AWS deployment. It has multiple Availability Zones inside Mumbai, but no cross-region disaster recovery capability. This means it can tolerate some Availability Zone level failures, but it cannot survive a complete Mumbai regional failure without major disruption.

## Compute Layer

The application tier runs on Amazon EKS across three Availability Zones:

- ap-south-1a
- ap-south-1b
- ap-south-1c

The EKS cluster contains 24 worker nodes and approximately 180 pods across 12 microservices:

1. payment-api
2. transaction-processor
3. settlement-engine
4. fraud-detection
5. notification-service
6. merchant-portal
7. reconciliation-worker
8. audit-logger
9. tokenisation-service
10. webhook-dispatcher
11. rate-limiter
12. health-monitor

Horizontal Pod Autoscaling is configured using CPU utilization and custom TPS metrics. The target CPU threshold is 60%. This gives the platform some elasticity during traffic spikes, but the scaling is limited to the Mumbai region.

## Database Layer

The main transactional database is Amazon Aurora PostgreSQL 15.4. It uses a Multi-AZ cluster with one writer instance and two reader replicas. The Aurora database stores:

- transaction records
- merchant configuration
- tokenised card references
- settlement batches
- payment state transitions

DynamoDB is used for session management and idempotency keys. Its provisioned capacity is 10,000 RCU and 5,000 WCU. This table is critical because payment systems must prevent duplicate processing when customers retry the same payment request.

ElastiCache Redis is used for merchant configuration caching, rate-limiting counters, and frequently accessed transaction lookups. Redis improves latency but is not the system of record.

## Messaging Layer

Amazon MSK Kafka is used as the event streaming backbone. The cluster contains six brokers and handles transaction events, settlement triggers, webhook deliveries, and audit log ingestion. It processes around 50,000 messages per second during peak periods and has a 7-day retention policy.

Kafka is a major dependency because several downstream workflows rely on event delivery. If Kafka fails, webhook delivery, reconciliation, settlement processing, and audit logging may be delayed.

## Networking Layer

External traffic enters through an Application Load Balancer protected by AWS WAF. All services are placed inside private subnets across three Availability Zones. Inter-service communication uses Istio service mesh with mTLS.

The VPC connects to corporate networks and partner bank VPNs using Transit Gateway. PrivateLink endpoints are used for private access to AWS services such as S3, KMS, and Secrets Manager.

## Security and Compliance Layer

AWS KMS is used for encryption keys. AWS Secrets Manager stores database credentials, API keys, and partner certificates with rotation every 90 days. CloudTrail records API activity and GuardDuty monitors suspicious behavior.

The cardholder data environment is separated using PCI DSS segmentation controls. Tokenisation-service and related database paths are considered part of the sensitive payment boundary.

## Observability Layer

The current observability stack includes:

- Prometheus for metrics
- Grafana for dashboards
- ELK for log aggregation
- PagerDuty for incident alerting
- Jaeger for distributed tracing
- CloudWatch for infrastructure metrics

The current setup monitors around 2,400 metrics and 350 active alerts. However, monitoring itself is also region-dependent, which means visibility may be reduced during a Mumbai regional outage.

## Current Failure Domains

The current architecture has the following major failure domains:

| Failure Domain | Impact |
|---|---|
| Single AWS region | Complete regional outage stops payment processing |
| Aurora writer | Payment writes fail |
| DynamoDB idempotency table | Duplicate payment protection is weakened |
| Redis cluster | Cache and rate-limiting degradation |
| MSK Kafka | Settlement, webhook, and audit workflows delayed |
| Route 53 / DNS | Users and merchants cannot reach API |
| KMS | Services cannot decrypt secrets |
| EKS control plane or worker nodes | Application availability degraded |

## Single Points of Failure

The largest single point of failure is regional dependency on ap-south-1. Multi-AZ protects against local AZ failure but not against a full regional event. The current design also lacks a promoted database writer in another Indian region, lacks automated Route 53 regional failover, and lacks an operationally tested DR runbook set for cross-region recovery.

## Conclusion

The current architecture is strong at the single-region level but insufficient for regulatory-grade disaster recovery. It must evolve into a multi-region architecture using Mumbai as the primary region and Hyderabad as the disaster recovery region. The future design must preserve data locality inside India, reduce RPO below 1 minute, achieve RTO below 5 minutes, and prevent duplicate payments during failover.
