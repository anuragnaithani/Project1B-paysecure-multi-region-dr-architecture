# Runbook 12: Disaster Recovery Drill

## Severity
Planned Exercise

## Objective
Test DR readiness without customer impact.

## Scope
- Route 53 failover simulation
- Aurora failover simulation
- Kafka replication validation
- EKS scaling validation
- Compliance evidence capture

## Steps

~~~bash
aws route53 get-health-check-status --health-check-id HEALTH_CHECK_ID
aws rds describe-global-clusters
kubectl get pods -n production
kubectl top pods -n production
~~~

## Success Criteria
- RTO under 5 minutes
- RPO under 1 minute
- No payment data leaves India
- Runbooks executed successfully
- Evidence saved for audit

## Evidence
Save:
- Screenshots
- CloudWatch metrics
- CloudTrail logs
- Incident timeline
- Sign-off sheet

## Stakeholder Sign-Off
- CTO
- CRO
- Compliance Head
- VP Engineering
- External Auditor
