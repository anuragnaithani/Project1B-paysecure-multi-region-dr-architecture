# Data Flow Diagrams

## Regulated Payment Data Flow

~~~mermaid
flowchart LR
    U[Customer] --> M[Merchant]
    M --> API[PaySecure API Mumbai]
    API --> DB[Aurora PostgreSQL Mumbai]
    API --> DDB[DynamoDB Mumbai]
    DB -.replication.-> HDR[Aurora Hyderabad]
    DDB -.global table.-> HDDB[DynamoDB Hyderabad]
~~~

## Cardholder Data Boundary

~~~mermaid
flowchart TB
    subgraph PCI_CDE[PCI DSS Cardholder Data Environment]
        TOKEN[tokenisation-service]
        KMS[AWS KMS]
        DB[(Encrypted Token Store)]
    end

    API[payment-api] --> TOKEN
    TOKEN --> KMS
    TOKEN --> DB
~~~

## DR Data Localisation
All regulated records replicate only between ap-south-1 and ap-south-2.
