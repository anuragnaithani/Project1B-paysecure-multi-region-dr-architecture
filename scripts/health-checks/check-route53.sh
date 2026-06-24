#!/bin/bash
echo "Checking Route53 health"
aws route53 list-health-checks
