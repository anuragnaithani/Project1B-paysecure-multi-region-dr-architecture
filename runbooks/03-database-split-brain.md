# Runbook 03: Database Split-Brain Incident

## Severity
P1 Critical

## Objective
Prevent duplicate transaction processing when two regions appear writable.

## Detection
- Two database clusters accepting writes
- Duplicate transaction IDs
- Idempotency key conflict
- Settlement mismatch

## Immediate Actions
1. Stop writes in the suspected secondary region.
2. Freeze settlement batch generation.
3. Disable merchant payout jobs.
4. Start reconciliation bridge.

## Containment Commands
~~~bash
kubectl scale deployment payment-api --replicas=0 -n production
kubectl scale deployment transaction-processor --replicas=0 -n production
kubectl scale deployment settlement-engine --replicas=0 -n production
~~~

Lock settlement jobs:

~~~bash
kubectl scale cronjob settlement-batch --replicas=0 -n production
~~~

## Investigation Queries
~~~sql
select transaction_id, count(*)
from transactions
group by transaction_id
having count(*) > 1;

select merchant_id, payment_id, count(*)
from idempotency_records
group by merchant_id, payment_id
having count(*) > 1;
~~~

## Recovery
- Choose system of record based on latest confirmed Aurora writer.
- Reconcile duplicate records.
- Keep only one successful transaction per idempotency key.
- Mark conflicting records as REVIEW_REQUIRED.
- Resume traffic only after Compliance and CTO approval.

## Validation
- No duplicate transaction IDs.
- Settlement totals match bank reports.
- Kafka replay does not create duplicate payments.
