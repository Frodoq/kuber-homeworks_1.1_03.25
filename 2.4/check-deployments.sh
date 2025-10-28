#!/bin/bash

echo "=== Checking all namespaces ==="
kubectl get namespaces | grep -E "app1|app2"

echo -e "\n=== Checking all deployments ==="
kubectl get deployments -n app1
kubectl get deployments -n app2

echo -e "\n=== Checking all pods ==="
kubectl get pods -n app1 -o wide
kubectl get pods -n app2 -o wide

echo -e "\n=== Checking all services ==="
kubectl get services -n app1
kubectl get services -n app2

echo -e "\n=== Checking images versions ==="
echo "Namespace app1:"
kubectl get pods -n app1 -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'

echo -e "\nNamespace app2:"
kubectl get pods -n app2 -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'

echo -e "\n=== Deployment details ==="
for ns in app1 app2; do
    echo "Namespace: $ns"
    kubectl get deployments,services,pods -n $ns
    echo "---"
done
