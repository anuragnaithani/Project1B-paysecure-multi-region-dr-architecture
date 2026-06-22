# Cost Estimate

## Current Annual Spend
PaySecure current annual infrastructure spend is approximately 8 crore INR.

## Estimated DR Cost
Hot standby DR is expected to increase cost by 40% to 60%.

| Item | Estimate |
|---|---|
| Current yearly cost | 8 crore INR |
| Additional DR cost | 3.2 to 4.8 crore INR |
| New estimated yearly cost | 11.2 to 12.8 crore INR |

## Major Cost Drivers
- Second EKS cluster in Hyderabad
- Aurora Global Database replica
- DynamoDB Global Tables write replication
- Redis Global Datastore
- MSK Replicator traffic
- Cross-region data transfer
- Observability and security tooling

## Cost Control
- Run minimum hot capacity in Hyderabad
- Autoscale only during failover
- Keep non-critical batch workloads disabled in DR
- Compress logs before replication
- Use lifecycle policies for S3 and log storage
