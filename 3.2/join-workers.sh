#!/bin/bash
WORKERS=("10.0.1.27" "10.0.1.9" "10.0.1.24" "10.0.1.3")
JOIN_COMMAND="kubeadm join 10.0.1.15:6443 --token xda5x8.45vhv91gz6g8kclp --discovery-token-ca-cert-hash sha256:88d90db46f389550bab7cfa66c3768cd159c8dda2b06990444e273c59adcd716"

for worker in "${WORKERS[@]}"; do
    echo "=== Joining worker: $worker to cluster ==="
    ssh $worker "sudo $JOIN_COMMAND"
    echo "=== Worker $worker joined ==="
    echo
done
