#!/bin/bash
# Author: Nishant Bhardwaj <nishant.bhardwaj0394@gmail.com>
# Email: nishant.bhardwaj0394@gmail.com

COUNT=1

for INSTANCE_ID in $(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=production" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)
do
    NEW_NAME="production-${COUNT}"

    echo "Renaming $INSTANCE_ID -> $NEW_NAME"

    aws ec2 create-tags \
        --resources "$INSTANCE_ID" \
        --tags Key=Name,Value="$NEW_NAME"

    ((COUNT++))
done
