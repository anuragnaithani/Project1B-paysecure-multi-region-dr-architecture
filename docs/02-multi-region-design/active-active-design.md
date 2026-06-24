# Active-Active Multi-Region Design

## Overview

This document evaluates a theoretical Active-Active deployment across Mumbai and Hyderabad.

## Architecture

Both regions simultaneously process live payment traffic.

Components:

- Dual EKS clusters
- Dual Aurora writers
- DynamoDB Global Tables
- Redis Global Datastore
- Kafka replicated topics

## Benefits

- Near-zero failover
- Lower downtime
- Regional load distribution

## Risks

### Split Brain

Network partitions can cause conflicting writes.

### Duplicate Payments

The same transaction may be processed in multiple regions.

### Settlement Inconsistency

Financial records may diverge.

### Regulatory Complexity

Difficult to explain conflict resolution to auditors.

## Cost Impact

Estimated infrastructure cost:

- Active-Passive: 1.4x
- Active-Active: 2.0x

## Decision

PaySecure rejects Active-Active as the primary architecture due to transaction consistency risks.
