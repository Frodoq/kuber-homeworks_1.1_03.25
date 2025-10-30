#!/bin/bash
WORKERS=("10.0.1.27" "10.0.1.9" "10.0.1.24" "10.0.1.3")

for worker in "${WORKERS[@]}"; do
    echo "=== Installing kubeadm on worker: $worker ==="
    ssh $worker "
        sudo apt update
        sudo apt install -y apt-transport-https ca-certificates curl
        curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
        echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
        sudo apt update
        sudo apt install -y kubelet kubeadm kubectl
        sudo apt-mark hold kubelet kubeadm kubectl
        sudo systemctl enable kubelet
        echo 'Kubeadm installed on $worker'
    "
    echo "=== Worker $worker ready for join ==="
    echo
done
