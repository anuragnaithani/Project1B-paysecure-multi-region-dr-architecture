# Runbook 08: Peak Load Failover

## Severity
P1 Critical

## Objective
Maintain transaction processing during Diwali, sale events and high TPS periods.

## Detection
- TPS exceeds 1200
- CPU utilization >80%
- P99 latency above 300 ms
- API success rate below 99.5%

## Immediate Actions
1. Scale EKS nodes.
2. Increase pod replicas.
3. Prioritize payment services.
4. Delay non-critical batch jobs.

## Commands

~~~bash
kubectl scale deployment payment-api --replicas=50 -n production
kubectl scale deployment transaction-processor --replicas=50 -n production
kubectl scale deployment settlement-engine --replicas=10 -n production
~~~

## Validation

- Transaction success >99.5%
- P99 latency <300 ms
- Kafka lag stable
