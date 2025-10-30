#!/bin/bash
WORKERS=("10.0.1.27" "10.0.1.9" "10.0.1.24" "10.0.1.3")

for worker in "${WORKERS[@]}"; do
    echo "=== Checking containerd on worker: $worker ==="
    ssh $worker "
        sudo systemctl status containerd --no-pager
        echo '---'
        sudo ctr version
        echo '---'
        cat /proc/sys/net/bridge/bridge-nf-call-iptables
        cat /proc/sys/net/ipv4/ip_forward
    "
    echo "=== Worker $worker check done ==="
    echo
done
