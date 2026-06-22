# Architecture Decision Record

## Decision
PaySecure will use Active-Passive Hot Standby across AWS Mumbai and Hyderabad.

## Selected Regions
- Primary: ap-south-1 Mumbai
- DR: ap-south-2 Hyderabad

## Reason
Active-passive is selected because payment gateways require strong consistency and low duplicate-payment risk. Active-active can reduce RTO, but it increases split-brain, idempotency conflict, and settlement mismatch risk.

## Accepted Trade-Offs
- Slight failover delay is accepted.
- DR region will run hot standby capacity.
- Infrastructure cost increases, but operational risk is lower than active-active.

## RPO and RTO
- RPO target: less than 1 minute
- RTO target: less than 5 minutes

## Data Localisation
All payment, transaction, merchant and cardholder data remains inside Indian AWS regions only.
