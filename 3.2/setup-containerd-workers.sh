#!/bin/bash
WORKERS=("10.0.1.27" "10.0.1.9" "10.0.1.24" "10.0.1.3")

for worker in "${WORKERS[@]}"; do
    echo "=== Setting up containerd on worker: $worker ==="
    ssh $worker "
        # Установка containerd
        sudo apt update
        sudo apt install -y containerd
        
        # Настройка конфигурации containerd
        sudo mkdir -p /etc/containerd
        containerd config default | sudo tee /etc/containerd/config.toml
        
        # Включение SystemdCgroup
        sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
        
        # Перезапуск containerd
        sudo systemctl daemon-reload
        sudo systemctl enable containerd
        sudo systemctl restart containerd
        
        # Настройка сетевых параметров
        echo 'net.bridge.bridge-nf-call-iptables = 1' | sudo tee -a /etc/sysctl.conf
        echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
        sudo sysctl --system
        
        # Загрузка модулей ядра
        sudo modprobe br_netfilter
        echo 'br_netfilter' | sudo tee -a /etc/modules-load.d/k8s.conf
        
        echo 'Containerd setup completed on $worker'
    "
    echo "=== Worker $worker containerd setup done ==="
    echo
done
