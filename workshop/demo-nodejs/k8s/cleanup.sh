#!/bin/bash

# Cleanup script for Demo Node.js Application Kubernetes deployment

echo "🧹 Cleaning up Kubernetes resources..."

# Delete all resources in the demo-nodejs namespace
echo "Deleting application resources..."
kubectl delete -f k8s/api-ingress.yaml
kubectl delete -f k8s/api-service.yaml
kubectl delete -f k8s/api-deployment.yaml
kubectl delete -f k8s/database-services.yaml
kubectl delete -f k8s/redis-pod.yaml
kubectl delete -f k8s/mysql-pod.yaml
kubectl delete -f k8s/persistent-volumes.yaml
kubectl delete -f k8s/secrets.yaml
kubectl delete -f k8s/configmaps.yaml
kubectl delete -f k8s/namespace.yaml

echo "✅ Cleanup completed!"
echo ""
echo "Note: Persistent data in /tmp/mysql-data and /tmp/redis-data may still exist"
echo "To remove data completely, run:"
echo "sudo rm -rf /tmp/mysql-data /tmp/redis-data"