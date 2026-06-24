# Active-Active vs Active-Passive Comparison Matrix

## Purpose

This document compares two possible multi-region disaster recovery designs for PaySecure Gateway Private Limited: Active-Active and Active-Passive Hot Standby. The final recommendation is Active-Passive Hot Standby with selective active-active components such as DynamoDB Global Tables for idempotency.

## Comparison Table

| Dimension | Active-Active | Active-Passive Hot Standby | Recommendation |
|---|---|---|---|
| RTO | Near-zero because both regions serve traffic | 1 to 5 minutes depending on DNS, database promotion, and service warm-up | Active-Passive meets target RTO under 5 minutes |
| RPO | Depends on replication model; conflict risk exists | Less than 1 minute using Aurora Global Database and DynamoDB Global Tables | Active-Passive gives simpler RPO control |
| Cost | Around 2x infrastructure cost because both regions run full capacity | Around 1.3x to 1.6x because DR runs warm/hot capacity | Active-Passive is more cost-efficient |
| Complexity | Very high due to multi-writer coordination and conflict resolution | Moderate because one region remains writer during normal operations | Active-Passive is operationally safer |
| Data Consistency | Eventual consistency unless complex distributed locking is implemented | Stronger consistency because Mumbai remains primary writer | Active-Passive reduces settlement mismatch |
| Latency Impact | Cross-region coordination can add 15-25 ms or more | No write-path cross-region latency during normal operations | Active-Passive protects current P99 latency |
| Split-Brain Risk | High during network partition | Lower because only one writer region is active | Active-Passive is safer for payments |
| Operational Burden | Requires both regions to be fully monitored, patched, scaled and operated 24x7 | DR region runs hot standby with reduced normal traffic | Active-Passive is realistic for 8 platform engineers |
| Regulatory Approval | Needs stronger justification due to duplicate transaction risk | Easier to explain to RBI, PCI DSS, and auditors | Active-Passive has simpler compliance narrative |
| Scaling | Can distribute traffic regionally | Primary region handles normal load; DR scales during failover | Active-Passive is sufficient for current volume |
| Failure Handling | Regional failure removes one traffic destination but data conflicts may remain | Failover must be executed, but recovery path is controlled | Active-Passive is easier to test |
| Merchant Impact | Lower DNS dependency but higher reconciliation risk | Short failover window but reduced duplicate payment risk | Active-Passive provides better financial control |

## Quantified Latency Analysis

Current P99 transaction latency is 180 ms. NPCI UPI transaction ceiling is 300 ms. This leaves a latency budget of:

300 ms - 180 ms = 120 ms

Mumbai to Hyderabad round-trip latency is estimated at 15-25 ms. In an active-active design, every strongly coordinated write could consume part of this budget. If multiple components require cross-region acknowledgement, the added latency could push P99 latency close to or beyond the 300 ms threshold.

In active-passive mode, normal transaction writes stay inside Mumbai. Cross-region replication happens asynchronously for Aurora, Redis, Kafka, and S3, while DynamoDB Global Tables support idempotency replication. This keeps customer-facing latency stable.

## Financial Risk Comparison

PaySecure processes approximately 500 crore INR daily. This equals:

500 crore / 24 = 20.83 crore INR per hour

A split-brain event lasting 3 minutes during peak payment traffic can create duplicate authorisations, settlement mismatches, webhook duplication, and merchant reconciliation issues. Active-active provides faster traffic continuity, but the potential financial exposure is higher if both regions process the same merchant transaction independently.

Active-passive reduces this risk by maintaining a single write authority during normal operation.

## Operational Feasibility

The platform engineering team has 8 engineers. Active-active multi-region payments architecture requires continuous expertise in:

- distributed transactions
- conflict resolution
- cross-region observability
- multi-region incident response
- settlement reconciliation
- dual-region deployment safety

This is a high operational burden. Active-passive hot standby is more realistic because the team can focus on maintaining one primary production path and one tested recovery path.

## Final Recommendation

PaySecure should implement Active-Passive Hot Standby across:

- Primary Region: ap-south-1 Mumbai
- DR Region: ap-south-2 Hyderabad

Selective active-active should be used only where it improves safety without creating unacceptable financial risk. DynamoDB Global Tables are acceptable for idempotency because deterministic keys can reduce duplicate payment processing.

This design meets the business requirement of 99.99% uptime, RPO below 1 minute, and RTO below 5 minutes while keeping payment consistency, regulatory explainability, and engineering effort under control.
