#!/bin/bash

echo "Setting up NGINX Ingress Controller..."

# Check if ingress-nginx namespace exists
if kubectl get namespace ingress-nginx &> /dev/null; then
    echo "NGINX Ingress Controller already exists"
else
    echo "Installing NGINX Ingress Controller..."
    
    # For minikube
    if command -v minikube &> /dev/null && minikube status &> /dev/null; then
        echo "Detected minikube, enabling ingress addon..."
        minikube addons enable ingress
    else
        # For other Kubernetes clusters
        echo "Installing NGINX Ingress Controller using Helm or kubectl..."
        kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml
        
        echo "Waiting for ingress controller to be ready..."
        kubectl wait --namespace ingress-nginx \
          --for=condition=ready pod \
          --selector=app.kubernetes.io/component=controller \
          --timeout=120s
    fi
fi

echo "Ingress controller setup complete!"
echo "You can now deploy the application using ./deploy.sh"
