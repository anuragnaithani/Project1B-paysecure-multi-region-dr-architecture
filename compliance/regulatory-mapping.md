# Regulatory Mapping

| Requirement | Design Decision |
|---|---|
| RBI payment system resilience | Multi-region DR across Mumbai and Hyderabad |
| RPO near zero | Aurora Global Database and DynamoDB Global Tables |
| RTO under 5 minutes | Route 53 failover, warm EKS capacity, automated runbooks |
| India data localisation | Payment data stays only in ap-south-1 and ap-south-2 |
| PCI-DSS v4.0 incident response | 12 DR runbooks with roles, escalation and recovery steps |
| NPCI uptime requirement | Automated health checks and failover within 5 minutes |
| Audit evidence | CloudTrail, Config, GuardDuty, SIEM and DR drill reports |
| Encryption | KMS multi-region keys, TLS 1.3, AES-256 at rest |
| Access control | Least privilege IAM, break-glass access, MFA |
| DR testing | Quarterly tabletop test and semi-annual full failover drill |
