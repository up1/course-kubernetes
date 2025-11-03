#!/bin/bash

# Kubernetes Deployment Script for Demo Node.js Application
# This script deploys the application to minikube

echo "🚀 Starting deployment to Minikube..."

# Check if minikube is running
if ! minikube status | grep -q "Running"; then
    echo "❌ Minikube is not running. Please start minikube first with: minikube start"
    exit 1
fi

# Enable NGINX Ingress Controller
echo "📦 Enabling NGINX Ingress Controller..."
minikube addons enable ingress

# Build Docker images in minikube environment
echo "🏗️  Building Docker images..."
eval $(minikube docker-env)

# Build API image
echo "Building API image..."
docker build -t demo-nodejs-api:latest ./api/

# Apply Kubernetes manifests in order
echo "📄 Applying Kubernetes manifests..."

# 1. Namespace
kubectl apply -f k8s/namespace.yaml

# 2. ConfigMaps and Secrets
kubectl apply -f k8s/configmaps.yaml
kubectl apply -f k8s/secrets.yaml

# 3. Persistent Volumes
kubectl apply -f k8s/persistent-volumes.yaml

# 4. Database Pods and Services
kubectl apply -f k8s/mysql-pod.yaml
kubectl apply -f k8s/redis-pod.yaml
kubectl apply -f k8s/database-services.yaml

# Wait for databases to be ready
echo "⏳ Waiting for database pods to be ready..."
kubectl wait --for=condition=Ready pod/mysql-pod -n demo-nodejs --timeout=300s
kubectl wait --for=condition=Ready pod/redis-pod -n demo-nodejs --timeout=300s

# 5. API Deployment and Service
kubectl apply -f k8s/api-deployment.yaml
kubectl apply -f k8s/api-service.yaml

# Wait for API deployment to be ready
echo "⏳ Waiting for API deployment to be ready..."
kubectl wait --for=condition=Available deployment/api-deployment -n demo-nodejs --timeout=300s

# 6. Ingress
kubectl apply -f k8s/api-ingress.yaml

# Get minikube IP for ingress
MINIKUBE_IP=$(minikube ip)

echo "✅ Deployment completed!"
echo ""
echo "📋 Deployment Summary:"
echo "===================="
echo "Namespace: demo-nodejs"
echo "API Replicas: 2"
echo "Databases: MySQL 8, Redis 8"
echo ""
echo "🌐 Access Information:"
echo "====================="
echo "Minikube IP: $MINIKUBE_IP"
echo "Add this to your /etc/hosts file:"
echo "$MINIKUBE_IP demo-nodejs.local"
echo ""
echo "Once added, access your application at: http://demo-nodejs.local"
echo ""
echo "🔍 Useful Commands:"
echo "=================="
echo "Check pod status: kubectl get pods -n demo-nodejs"
echo "Check services: kubectl get svc -n demo-nodejs"
echo "Check ingress: kubectl get ingress -n demo-nodejs"
echo "View API logs: kubectl logs -f deployment/api-deployment -n demo-nodejs"
echo "View MySQL logs: kubectl logs -f mysql-pod -n demo-nodejs"
echo "View Redis logs: kubectl logs -f redis-pod -n demo-nodejs"