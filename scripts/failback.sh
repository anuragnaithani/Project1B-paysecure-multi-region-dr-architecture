#!/bin/bash

echo "Initiating failback"

aws route53 change-resource-record-sets \
--hosted-zone-id HOSTED_ZONE_ID \
--change-batch file://configs/route53-failback-mumbai.json

echo "Failback completed"
