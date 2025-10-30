#!/bin/bash

NODES=("10.0.1.27" "10.0.1.9" "10.0.1.24" "10.0.1.3")

for node in "${NODES[@]}"; do
    echo "Testing SSH connection to $node"
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 ubuntu@$node "echo 'SSH connection successful to $node'" || echo "Failed to connect to $node"
done
