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

grep -vF -f <(echo '
36.103.232.0/25
36.103.232.128/26
52.82.128.0/19
58.254.138.0/25
58.254.138.128/26
116.129.226.0/25
116.129.226.128/26
118.193.97.128/25
118.193.97.64/26
119.147.182.0/25
119.147.182.128/26
120.232.236.0/25
120.232.236.128/26
120.253.240.192/26
120.253.241.160/27
120.253.245.128/26
120.253.245.192/27
120.52.12.64/26
120.52.153.192/26
120.52.22.96/27
120.52.39.128/27
180.163.57.0/25
180.163.57.128/26
204.246.168.0/22
204.246.172.0/24
204.246.173.0/24
204.246.174.0/23
223.71.11.0/27
223.71.71.128/25
223.71.71.96/27
') /tmp/CLOUDFRONT-ipv4.txt | sort -h | uniq > /amazon/cloudfront.txt
# sort & uniq
sort -h /tmp/CLOUDFRONT-ipv4.txt | uniq > amazon/cloudfront_ipv4.txt
sort -h /tmp/CLOUDFRONT-ipv6.txt | uniq > amazon/cloudfront_ipv6.txt

