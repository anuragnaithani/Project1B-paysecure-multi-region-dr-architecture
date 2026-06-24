# Runbook 10: Security Breach

## Severity
P1 Critical

## Objective
Contain compromise and protect payment data.

## Detection
- GuardDuty alerts
- Suspicious IAM activity
- Abnormal API calls

## Immediate Actions

1. Declare security incident.
2. Disable compromised credentials.
3. Isolate workloads.
4. Enable forensic logging.

## Commands

~~~bash
aws iam update-access-key --access-key-id ACCESS_KEY --status Inactive

kubectl scale deployment payment-api --replicas=0 -n production
~~~

## Validation

- Threat contained
- No unauthorized access
- Audit logs preserved

## Compliance

- RBI reporting
- PCI DSS incident response
