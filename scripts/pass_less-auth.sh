#!/bin/bash
# Author: Nishant Bhardwaj <nishant.bhardwaj0394@gmail.com>
# Email: nishant.bhardwaj0394@gmail.com

PEM_FILE="/home/nishant/Code/ansible/ansible_demo.pem"
PUB_KEY="$HOME/.ssh/id_ed25519.pub"
USER="ubuntu"

grep "ansible_host:" hosts.yaml | awk '{print $2}' | while read -r IP
do
    echo "Installing key on $IP"

    ssh-copy-id \
      -f \
      -i "$PUB_KEY" \
      -o IdentityFile="$PEM_FILE" \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      "$USER@$IP"
done

