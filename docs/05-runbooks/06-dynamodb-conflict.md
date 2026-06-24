# Runbook 06: DynamoDB Global Table Conflict

## Severity
P1 Critical

## Objective
Resolve idempotency key conflicts and prevent duplicate transaction processing.

## Detection
- Duplicate idempotency keys
- Last-writer-wins conflict alert
- Duplicate payment attempt for same merchant payment ID
- Transaction mismatch between Aurora and DynamoDB

## Immediate Actions
1. Stop payment write traffic if duplicate successful payments are detected.
2. Freeze settlement and payout jobs.
3. Export affected DynamoDB records.
4. Compare with Aurora transaction table.

## Investigation Commands
~~~bash
aws dynamodb describe-table \
  --table-name paysecure-idempotency \
  --region ap-south-1

aws dynamodb describe-table \
  --table-name paysecure-idempotency \
  --region ap-south-2
~~~

Query affected key:

~~~bash
aws dynamodb get-item \
  --table-name paysecure-idempotency \
  --key '{"idempotency_key":{"S":"MERCHANT_PAYMENT_REQUEST_HASH"}}'
~~~

## Resolution
- Keep the record with confirmed Aurora transaction ID.
- Mark conflicting record as DUPLICATE_REJECTED.
- Add merchant_id + payment_id + request_hash to conflict watchlist.
- Replay failed safe transactions only.

## Validation
- One successful transaction per idempotency key.
- No duplicate settlement entry.
- Merchant webhook receives only one success event.
