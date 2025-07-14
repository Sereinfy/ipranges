#!/bin/bash

# https://docs.aws.amazon.com/general/latest/gr/aws-ip-ranges.html

set -euo pipefail
set -x


# get from public ranges
curl -s https://ip-ranges.amazonaws.com/ip-ranges.json > /tmp/amazon.json


# save ipv4
jq '.prefixes[] | [.ip_prefix][] | select(. != null)' -r /tmp/amazon.json > /tmp/amazon-ipv4.txt

# save ipv6
jq '.ipv6_prefixes[] | [.ipv6_prefix][] | select(. != null)' -r /tmp/amazon.json > /tmp/amazon-ipv6.txt


# sort & uniq
sort -h /tmp/amazon-ipv4.txt | uniq > amazon/ipv4.txt
sort -h /tmp/amazon-ipv6.txt | uniq > amazon/ipv6.txt


# save ipv4 - only where service is CLOUDFRONT
jq '.prefixes[] | select(.service == "CLOUDFRONT") | [.ip_prefix][] | select(. != null)' -r /tmp/amazon.json > /tmp/CLOUDFRONT-ipv4.txt

# save ipv6 - only where service is CLOUDFRONT
jq '.ipv6_prefixes[] | select(.service == "CLOUDFRONT") | [.ipv6_prefix][] | select(. != null)' -r /tmp/amazon.json > /tmp/CLOUDFRONT-ipv6.txt


# sort & uniq
sort -h /tmp/CLOUDFRONT-ipv4.txt | uniq > amazon/cloudfront_ipv4.txt
sort -h /tmp/CLOUDFRONT-ipv6.txt | uniq > amazon/cloudfront_ipv6.txt
