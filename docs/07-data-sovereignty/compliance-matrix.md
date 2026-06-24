# Data Sovereignty Compliance Matrix

| Data Category | Examples | Residency Requirement | Region Scope | Protection |
|---|---|---|---|---|
| Cardholder Data | PAN tokens, card metadata | India only | Mumbai + Hyderabad | AES-256, TLS 1.3, KMS |
| Transaction Data | transaction_id, amount, status | India only | Mumbai + Hyderabad | Encryption and audit logs |
| Merchant Data | merchant profile, bank details | India only | Mumbai + Hyderabad | Field-level encryption |
| Idempotency Data | payment_id, request_hash | India only | Mumbai + Hyderabad | DynamoDB encryption |
| Audit Logs | API events, admin actions | India preferred | Indian regions | CloudTrail and SIEM |
| Operational Metrics | CPU, latency, health status | India preferred | Indian regions | No PII included |
| Configuration Data | feature flags, routing rules | No payment data | Indian regions | Secrets restricted |

## Compliance Position
All regulated payment data remains in Indian AWS regions. Singapore is not used for payment data storage.
