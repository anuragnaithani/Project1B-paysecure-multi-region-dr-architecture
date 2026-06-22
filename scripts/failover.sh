#!/bin/bash

echo "Initiating DR failover"

aws rds failover-global-cluster \
--global-cluster-identifier paysecure-global-db

echo "Updating Route53"

aws route53 change-resource-record-sets \
--hosted-zone-id HOSTED_ZONE_ID \
--change-batch file://configs/route53-failover-hyd.json

echo "Failover completed"
