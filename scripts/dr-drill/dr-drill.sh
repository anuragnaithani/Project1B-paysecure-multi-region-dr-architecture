#!/bin/bash

echo "Starting DR Drill"

./scripts/health-checks/check-route53.sh
./scripts/health-checks/check-aurora.sh
./scripts/health-checks/check-kafka.sh

echo "DR Drill Complete"
