# Cost Summary

## Current Cost Baseline
PaySecure current annual infrastructure spend is approximately 8 crore INR.

## DR Cost Estimate

| DR Tier | Cost Multiplier | Annual Estimate | RTO | RPO |
|---|---|---|---|---|
| Cold Standby | 1.1x | 8.8 crore | Hours | Hours |
| Warm Standby | 1.3x | 10.4 crore | 15-30 min | < 15 min |
| Hot Standby | 1.4x-1.6x | 11.2-12.8 crore | < 5 min | < 1 min |
| Active-Active | 2.0x | 16 crore | Near-zero | Depends on conflict strategy |

## Recommended Tier
Hot Standby is recommended because it meets RTO and RPO targets without the complexity of active-active.

## Major Cost Drivers
- EKS worker nodes in Hyderabad
- Aurora Global Database replica
- DynamoDB Global Tables replication writes
- Redis Global Datastore
- MSK Replicator and cross-region transfer
- Observability stack
- Security tooling

## Cost Control Measures
- Run minimum hot capacity in Hyderabad
- Scale up only during failover
- Keep batch workloads disabled in standby
- Use lifecycle policies for logs
- Use Savings Plans for steady compute
