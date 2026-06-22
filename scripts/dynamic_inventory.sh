#!/bin/bash
# Author: Nishant Bhardwaj <nishant.bhardwaj0394@gmail.com>
# Email: nishant.bhardwaj0394@gmail.com

OUTPUT_FILE="hosts.yaml"

echo "all:" > "$OUTPUT_FILE"
echo "  hosts:" >> "$OUTPUT_FILE"

aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=production-*" \
            "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value|[0],PublicIpAddress]' \
  --output text |
while read -r NAME IP
do
    cat >> "$OUTPUT_FILE" << EOF
    $NAME:
      ansible_host: $IP
EOF
done

echo "Generated $OUTPUT_FILE"
cat "$OUTPUT_FILE"
