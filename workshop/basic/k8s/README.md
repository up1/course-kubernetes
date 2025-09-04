# Kubernetes Deployment for Demo Application

This directory contains Kubernetes manifest files converted from the Docker Compose configuration.

## Files Overview

- `namespace.yaml` - Creates the demo-app namespace
- `mongodb-secret.yaml` - Contains MongoDB credentials (base64 encoded)
- `mongodb-pvc.yaml` - Persistent Volume Claim for MongoDB data
- `mongodb-deployment.yaml` - MongoDB deployment with health checks
- `mongodb-service.yaml` - ClusterIP service for MongoDB
- `api-deployment.yaml` - Go API deployment with health checks and resource limits
- `api-service.yaml` - ClusterIP service for the API
- `api-ingress.yaml` - Ingress configuration for external access
- `deploy.sh` - Script to deploy all resources in correct order
- `setup-ingress.sh` - Script to set up NGINX Ingress Controller

## Prerequisites

1. A running Kubernetes cluster (minikube, kind, or cloud provider)
2. kubectl configured to connect to your cluster
3. NGINX Ingress Controller (run `./setup-ingress.sh` if not installed)

## Quick Start

1. **Set up Ingress Controller (if needed):**
   ```bash
   ./setup-ingress.sh
   ```

2. **Deploy the application:**
   ```bash
   ./deploy.sh
   ```

3. **Access the application:**
   - Add to your `/etc/hosts` file: `127.0.0.1 api.demo.local`
   - Access via: `http://api.demo.local`
   - Or access via: `http://localhost/api` (if ingress controller runs on localhost)

## Manual Deployment

If you prefer to deploy manually:

```bash
# 1. Create namespace
kubectl apply -f namespace.yaml

# 2. Create secrets and storage
kubectl apply -f mongodb-secret.yaml
kubectl apply -f mongodb-pvc.yaml

# 3. Deploy MongoDB
kubectl apply -f mongodb-deployment.yaml
kubectl apply -f mongodb-service.yaml

# 4. Wait for MongoDB to be ready
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n demo-app

# 5. Deploy API
kubectl apply -f api-deployment.yaml
kubectl apply -f api-service.yaml
kubectl apply -f api-ingress.yaml

# 6. Wait for API to be ready
kubectl wait --for=condition=available --timeout=300s deployment/api -n demo-app
```

## Checking Status

```bash
# Check all resources
kubectl get all -n demo-app

# Check ingress
kubectl get ingress -n demo-app

# Check logs
kubectl logs -f deployment/api -n demo-app
kubectl logs -f deployment/mongodb -n demo-app
```

## API Endpoints

- Health check: `GET /health`
- Products: `GET /products`

## Configuration Notes

- MongoDB credentials are stored in Kubernetes secrets
- Persistent storage is used for MongoDB data
- Health checks are configured for both services
- Resource limits are set for optimal performance
- CORS is enabled in the Ingress for cross-origin requests

## Cleanup

To remove the application:

```bash
kubectl delete namespace demo-app
```
