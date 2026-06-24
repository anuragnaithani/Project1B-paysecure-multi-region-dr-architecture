# Runbook 09: KMS Key Incident

## Severity
P1 Critical

## Objective
Recover encrypted workloads after KMS failure.

## Detection
- Secrets decryption failure
- Database connection errors
- Application startup failures

## Immediate Actions
1. Verify KMS availability.
2. Switch to multi-region KMS key.
3. Restart affected workloads.

## Commands

~~~bash
aws kms list-keys --region ap-south-2

kubectl rollout restart deployment/payment-api -n production
kubectl rollout restart deployment/transaction-processor -n production
~~~

## Validation

- Secrets available
- Applications running
- No decryption errors
