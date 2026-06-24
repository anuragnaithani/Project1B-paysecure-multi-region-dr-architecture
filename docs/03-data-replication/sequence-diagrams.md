# Sequence Diagrams

## Normal Payment Write Path

~~~mermaid
sequenceDiagram
    participant User
    participant Route53
    participant ALB as Mumbai ALB
    participant API as payment-api
    participant DDB as DynamoDB Idempotency
    participant DB as Aurora PostgreSQL
    participant Kafka as MSK Kafka
    participant HYD as Hyderabad DR

    User->>Route53: Payment request
    Route53->>ALB: Resolve Mumbai endpoint
    ALB->>API: Forward HTTPS request
    API->>DDB: Check idempotency key
    DDB-->>API: Key not used
    API->>DB: Create transaction record
    DB-->>API: Commit success
    API->>Kafka: Publish transaction event
    Kafka-->>HYD: Replicate event
    DB-->>HYD: Aurora Global DB replication
    API-->>User: Payment accepted
~~~

## Failover Payment Path

~~~mermaid
sequenceDiagram
    participant Monitor
    participant R53 as Route53
    participant Aurora
    participant EKS as Hyderabad EKS
    participant API as Hyderabad payment-api
    participant User

    Monitor->>R53: Mumbai health check failed
    Monitor->>Aurora: Promote Hyderabad cluster
    Aurora-->>Monitor: New writer ready
    Monitor->>EKS: Scale payment services
    Monitor->>R53: Update DNS to Hyderabad
    User->>R53: Retry payment request
    R53->>API: Route to Hyderabad
    API-->>User: Payment processed
~~~
