# Business Continuity Review Board Presentation

## Stakeholders

1. CTO
2. Chief Risk Officer
3. Compliance Head
4. VP Engineering
5. External Auditor

---

## Current Problem

Current uptime:
99.92%

Target uptime:
99.99%

Current architecture:
Single AWS Mumbai region

Risk:
Single region failure can stop payment processing.

---

## Proposed Architecture

Primary Region:
Mumbai (ap-south-1)

DR Region:
Hyderabad (ap-south-2)

Architecture:
Active-Passive Hot Standby

Target RPO:
< 1 minute

Target RTO:
< 5 minutes

---

## Database Strategy

Aurora PostgreSQL:
Aurora Global Database

DynamoDB:
Global Tables

Redis:
Global Datastore

Kafka:
MSK Replicator

---

## Compliance Mapping

RBI Master Direction:
Compliant

PCI DSS v4.0:
Compliant

NPCI UPI Standards:
Compliant

India Data Localisation:
Compliant

---

## Risks

Split-brain

Replication lag

DNS failover delay

Kafka partition

KMS compromise

---

## Mitigation

12 production runbooks

Quarterly DR drills

CloudWatch monitoring

Route53 automated failover

Multi-region KMS

---

## Expected Availability

Current:
99.92%

Target:
99.99%

Estimated annual downtime:

Current:
~7 hours

Target:
~52 minutes

