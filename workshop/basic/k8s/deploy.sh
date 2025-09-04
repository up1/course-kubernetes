#!/bin/bash

# Deploy Kubernetes manifests in the correct order
echo "Deploying demo application to Kubernetes..."

# Apply namespace first
echo "Creating namespace..."
kubectl apply -f namespace.yaml

# Apply secrets and PVC
echo "Creating secrets and persistent volume claims..."
kubectl apply -f mongodb-secret.yaml
kubectl apply -f mongodb-pvc.yaml

# Deploy MongoDB
echo "Deploying MongoDB..."
kubectl apply -f mongodb-deployment.yaml
kubectl apply -f mongodb-service.yaml

# Wait for MongoDB to be ready
echo "Waiting for MongoDB to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n demo-app

# Deploy API
echo "Deploying API..."
kubectl apply -f api-deployment.yaml
kubectl apply -f api-service.yaml
kubectl apply -f api-ingress.yaml

# Wait for API to be ready
echo "Waiting for API to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/api -n demo-app

echo "Deployment complete!"
echo "You can access the API at:"
echo "  - http://api.demo.local (add '127.0.0.1 api.demo.local' to your /etc/hosts)"
echo "  - http://localhost/api (if ingress controller is running on localhost)"
echo "Check the status with: kubectl get pods -n demo-app"
echo "Check ingress status with: kubectl get ingress -n demo-app"
