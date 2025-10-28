#!/bin/bash

echo "Cleaning up deployments..."

kubectl delete namespace app1 --ignore-not-found=true
kubectl delete namespace app2 --ignore-not-found=true

rm -rf manifests/

echo "Cleanup completed!"
